import db_postgres, strutils

type
  User* = object
    id*: int
    name*: string
    username*: string
    email*: string

proc createNewUser*(id: int, name: string, username: string, email: string): User =
    result = User(
        id: id,
        name: name,
        username: username,
        email: email
    )

proc rowToUser(row: Row): User =
  result = createNewUser(parseInt(row[0]), row[1], row[2], row[3])

proc users_getAll*(db: DbConn): seq[User] =
  var rows: seq[Row] = db.getAllRows(sql"SELECT * FROM space_core.users")

  for row in rows:
    result.add(rowToUser(row))

proc users_getUserById*(db: DbConn, id: int): User =
  var row: Row = db.getRow(sql"SELECT * FROM space_core.users WHERE (id = ?)", id)
  result = rowToUser(row)

proc users_insertUser*(db: DbConn, user: User): int64 =
  var id: int64 = db.tryInsertID(
    sql"INSERT INTO space_core.users(name, username, email) VALUES (?, ?, ?)",
    user.name, user.username, user.email
  )
  return id
