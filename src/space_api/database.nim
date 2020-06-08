import db_postgres

# TODO: load values from env
proc db_init*(): DbConn =
    let db: DbConn = open("localhost", "local_user", "this_is_not_a_password", "space_core_db")
    return db

proc db_get_version*(db: DbConn): string =
    result = db.getValue(sql"SELECT version();")
    

proc db_close*(db: DbConn): void =
    db.close()
