import db_postgres, strutils

type
  AccountType* = enum
    bankAccount, creditAccount, savingsAccount

type
  Account = ref object of RootObj
    id*: int
    user_id*: int
    account_name*: string
    current_total*: float

type
  BankAccount* = ref object of Account
    account_type*: AccountType
  CreditAccount* = ref object of Account
    account_type*: AccountType
    maximum_total*: float
  SavingsAccount* = ref object of Account
    account_type*: AccountType

proc account_createNewAccount*(id: int, account_type: AccountType, user_id: int, account_name: string, current_total: float, maximum_total: float = 0): Account =
  case account_type:
    of AccountType.bankAccount:
      result = BankAccount(
        id: id,
        user_id: user_id,
        account_name: account_name,
        current_total: current_total
      )
    of AccountType.creditAccount:
      result = CreditAccount(
        id: id,
        user_id: user_id,
        account_name: account_name,
        current_total: current_total,
        maximum_total: maximum_total
      )
    of AccountType.savingsAccount:
      result = SavingsAccount(
        id: id,
        user_id: user_id,
        account_name: account_name,
        current_total: current_total
      )

proc rowToAccount(row: Row, account_type: AccountType): Account =
  case account_type:
    of AccountType.bankAccount:
      result = BankAccount(
        id: parseInt(row[0]),
        user_id: parseInt(row[1]),
        account_name: row[2],
        current_total: parseFloat(row[3])
      )
    of AccountType.creditAccount:
      result = CreditAccount(
        id: parseInt(row[0]),
        user_id: parseInt(row[1]),
        account_name: row[2],
        current_total: parseFloat(row[3]),
        maximum_total: parseFloat(row[4])
      )
    of AccountType.savingsAccount:
      result = SavingsAccount(
        id: parseInt(row[0]),
        user_id: parseInt(row[1]),
        account_name: row[2],
        current_total: parseFloat(row[3])
      )

proc account_getAll*(db: DbConn, account_type: AccountType): seq[Account] =
  case account_type:
    of AccountType.bankAccount:
      var rows: seq[Row] = db.getAllRows(sql"SELECT * FROM space_core.bank_account")
      for row in rows:
        result.add(rowToAccount(row, AccountType.bankAccount))

    of AccountType.creditAccount:
      var rows: seq[Row] = db.getAllRows(sql"SELECT * FROM space_core.credit_account")
      for row in rows:
        result.add(rowToAccount(row, AccountType.creditAccount))

    of AccountType.savingsAccount:
      var rows: seq[Row] = db.getAllRows(sql"SELECT * FROM space_core.savings_account")
      for row in rows:
        result.add(rowToAccount(row, AccountType.savingsAccount))

proc account_getAccountById*(db: DbConn, id: int, account_type: AccountType): Account =
  case account_type:
    of AccountType.bankAccount:
      var row: Row = db.getRow(sql"SELECT * FROM space_core.bank_account WHERE (id = ?)", id)
      result = rowToAccount(row, AccountType.bankAccount)

    of AccountType.creditAccount:
      var row: Row = db.getRow(sql"SELECT * FROM space_core.credit_account WHERE (id = ?)", id)
      result = rowToAccount(row, AccountType.creditAccount)

    of AccountType.savingsAccount:
      var row: Row = db.getRow(sql"SELECT * FROM space_core.savings_account WHERE (id = ?)", id)
      result = rowToAccount(row, AccountType.savingsAccount)

proc account_insertAccount*(db: DbConn, account: Account, account_type: AccountType, maximum_total: float = 0): int64 =
  case account_type:
    of AccountType.bankAccount:
      var id: int64 = db.tryInsertID(
        sql"INSERT INTO space_core.bank_account(user_id, account_name, current_total) VALUES (?, ?, ?)",
        account.user_id, account.account_name, account.current_total
      )
      return id
    
    of AccountType.creditAccount:
      var id: int64 = db.tryInsertID(
        sql"INSERT INTO space_core.credit_account(user_id, account_name, current_total, maximum) VALUES (?, ?, ?, ?)",
        account.user_id, account.account_name, account.current_total, maximum_total
      )
      return id

    of AccountType.savingsAccount:
      var id: int64 = db.tryInsertID(
        sql"INSERT INTO space_core.savings_account(user_id, account_name, current_total) VALUES (?, ?, ?)",
        account.user_id, account.account_name, account.current_total
      )
      return id
