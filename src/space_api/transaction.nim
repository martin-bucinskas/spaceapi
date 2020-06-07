type
  Transaction* = object
    id*: int
    tx_ref*: string
    tx_amount*: float
    tx_date*: string

proc createNewTransaction*(id: int, tx_ref: string, tx_amount: float, tx_date: string): Transaction =
    result = Transaction(
        id: id,
        tx_ref: tx_ref,
        tx_amount: tx_amount,
        tx_date: tx_date
    )
