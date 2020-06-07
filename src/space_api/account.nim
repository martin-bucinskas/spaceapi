type
  AccountType* = enum
    bankAccount, creditAccount, savingsAccount

type
  Account = ref object of RootObj
    id*: int
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

