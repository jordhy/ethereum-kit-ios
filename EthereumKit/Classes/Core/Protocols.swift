import RxSwift
import BigInt

protocol IBlockchain {
    var delegate: IBlockchainDelegate? { get set }

    var source: String { get }
    func start()
    func stop()
    func refresh()
    func syncAccountState()

    var syncState: SyncState { get }
    var lastBlockHeight: Int? { get }
    var accountState: AccountState? { get }

    func nonceSingle(defaultBlockParameter: DefaultBlockParameter) -> Single<Int>
    func sendSingle(rawTransaction: RawTransaction) -> Single<Transaction>

    func transactionReceiptSingle(transactionHash: Data) -> Single<RpcTransactionReceipt?>
    func transactionSingle(transactionHash: Data) -> Single<RpcTransaction?>
    func getStorageAt(contractAddress: Address, positionData: Data, defaultBlockParameter: DefaultBlockParameter) -> Single<Data>
    func call(contractAddress: Address, data: Data, defaultBlockParameter: DefaultBlockParameter) -> Single<Data>
    func estimateGas(to: Address?, amount: BigUInt?, gasLimit: Int?, gasPrice: Int?, data: Data?) -> Single<Int>
    func getBlock(blockNumber: Int) -> Single<RpcBlock?>
}

protocol IBlockchainDelegate: class {
    func onUpdate(lastBlockHeight: Int)
    func onUpdate(syncState: SyncState)
    func onUpdate(accountState: AccountState)
}

protocol ITransactionStorage {
    func notSyncedTransactions(limit: Int) -> [NotSyncedTransaction]
    func add(notSyncedTransactions: [NotSyncedTransaction])
    func update(notSyncedTransaction: NotSyncedTransaction)
    func remove(notSyncedTransaction: NotSyncedTransaction)

    func save(transaction: Transaction)
    func pendingTransactions(fromTransaction: Transaction?) -> [Transaction]
    func pendingTransaction(nonce: Int) -> Transaction?

    func save(transactionReceipt: TransactionReceipt)
    func transactionReceipt(hash: Data) -> TransactionReceipt?

    func save(logs: [TransactionLog])
    func save(internalTransactions: [InternalTransaction])

    func hashesFromTransactions() -> [Data]
    func etherTransactionsBeforeSingle(address: Address, hash: Data?, limit: Int?) -> Single<[FullTransaction]>
    func transaction(hash: Data) -> FullTransaction?
    func fullTransactions(byHashes: [Data]) -> [FullTransaction]
    func fullTransactionsAfter(syncOrder: Int?) -> [FullTransaction]
    func add(droppedTransaction: DroppedTransaction)
}

public protocol ITransactionSyncerStateStorage {
    func transactionSyncerState(id: String) -> TransactionSyncerState?
    func save(transactionSyncerState: TransactionSyncerState)
}

protocol ITransactionSyncerListener: class {
    func onTransactionsSynced(fullTransactions: [FullTransaction])
}

public protocol ITransactionSyncer {
    var id: String { get }
    var state: SyncState { get }
    var stateObservable: Observable<SyncState> { get }

    func set(delegate: ITransactionSyncerDelegate)
    func start()
    func onEthereumSynced()
    func onLastBlockNumber(blockNumber: Int)
    func onLastBlockBloomFilter(bloomFilter: BloomFilter)
    func onUpdateAccountState(accountState: AccountState)
}

public protocol ITransactionSyncerDelegate {
    var notSyncedTransactionsSignal: PublishSubject<Void> { get }
    func transactionSyncerState(id: String) -> TransactionSyncerState?
    func update(transactionSyncerState: TransactionSyncerState)
    func add(notSyncedTransactions: [NotSyncedTransaction])
    func notSyncedTransactions(limit: Int) -> [NotSyncedTransaction]
    func remove(notSyncedTransaction: NotSyncedTransaction)
    func update(notSyncedTransaction: NotSyncedTransaction)
}

protocol ITransactionManagerDelegate: AnyObject {
    func onUpdate(transactionsSyncState: SyncState)
    func onUpdate(transactionsWithInternal: [FullTransaction])
}

public protocol IDecorator {
    func decorate(transactionData: TransactionData) -> TransactionDecoration?
}
