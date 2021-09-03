from pprint import pprint

from twisted.internet.defer import inlineCallbacks

from autobahn.twisted.wamp import ApplicationSession
from autobahn.wamp.exception import ApplicationError
import sqlalchemy
from sqlalchemy import create_engine, MetaData
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Boolean, Column,Table, ForeignKey,Text, Integer, String, DateTime, Enum, Float
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine, select, MetaData, Table, and_


# our user "database"
USERDB = {
   'client1': {
      # these are required:
      'secret': 'secret123',  # the secret/password to be used
      'role': 'frontend'    # the auth role to be assigned when authentication succeeds
   },
   'joe': {
      # these are required:
      'secret': 'secret2',  # the secret/password to be used
      'role': 'frontend'    # the auth role to be assigned when authentication succeeds
   },
   'hans': {
      'authid': 'ID09125',  # assign a different auth ID during authentication
      'secret': '123456',
      'role': 'frontend'
   },
   'peter': {
      # use salted passwords

      # autobahn.wamp.auth.derive_key(secret.encode('utf8'), salt.encode('utf8')).decode('ascii')
      'secret': 'prq7+YkJ1/KlW1X0YczMHw==',
      'role': 'frontend',
      'salt': 'salt123',
      'iterations': 100,
      'keylen': 16
   }
}


class AuthenticatorSession(ApplicationSession):
   @inlineCallbacks
   def onJoin(self, details):
      def authenticate(realm, authid, details):
         print("WAMP-CRA dynamic authenticator invoked: realm='{}', authid='{}'".format(realm, authid))
         pprint(details)

         print('checking in database..')
         SQLALCHEMY_DATABASE_URL = "mysql+mysqlconnector://<user>:<pass>@host.docker.internal:3306/hzdb2"
         engine = create_engine(
            SQLALCHEMY_DATABASE_URL, echo=True#, connect_args={"check_same_thread": False}
         )
         SessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=engine)
         Base = declarative_base()
         meta = MetaData()

         users = Table(
            'user', meta, 
            Column('name', String)
         )

         metadata = MetaData(bind=None)
         users = Table(
         'user', 
         metadata, 
         autoload=True, 
         autoload_with=engine
         )
         stmt = select([
            users.columns.name]
         ).where(
            #TODO -remove 
            #users.columns.name == 'GiriC'
            users.columns.name == authid
         )

         connection = engine.connect()
         results = connection.execute(stmt).fetchall()
         print("results", results)
         if len(results) > 0:
            for row in results:
               if len(row) > 0:
                  print(row[0])
                  print("User found in database.!")
               else:
                  print("User not found in database.!")
            return {
                     # these are required:
                     'secret': 'secret2',  # the secret/password to be used
                     'role': 'frontend'    # the auth role to be assigned when authentication succeeds
                  }
         else:
            print("There are no users found in db with username : GiriCasd")
            raise ApplicationError('com.example.no_such_user', 'could not authenticate session - no such user {}'.format(authid))
        
         #TODO -remove below once tested
         # #if authid in USERDB:
         # if authid in USERDB:
         #    # return a dictionary with authentication information ...
         #    return USERDB[authid]
         # else:
         #    raise ApplicationError('com.example.no_such_user', 'could not authenticate session - no such user {}'.format(authid))
      try:
         yield self.register(authenticate, 'com.hz.authenticate')
         print("WAMP-CRA dynamic authenticator registered!")
      except Exception as e:
         print("Failed to register dynamic authenticator: {0}".format(e))


"""
def main():
   
   #SQLALCHEMY_DATABASE_URL = "mysql+mysqlconnector://stbitdbuser:9cAxIccp+p*vPJsA@host.docker.internal:3306/hzdb2"
   SQLALCHEMY_DATABASE_URL = "mysql+mysqlconnector://stbitdbuser:9cAxIccp+p*vPJsA@localhost:3306/hzdb2"
   engine = create_engine(
      SQLALCHEMY_DATABASE_URL, echo=True#, connect_args={"check_same_thread": False}
   )
   SessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=engine)
   Base = declarative_base()
   meta = MetaData()

   users = Table(
      'user', meta, 
      Column('name', String)
   )

   metadata = MetaData(bind=None)
   users = Table(
   'user', 
   metadata, 
   autoload=True, 
   autoload_with=engine
   )
   stmt = select([
      users.columns.name]
   ).where(
      users.columns.name == 'GiriC'
   )

   connection = engine.connect()
   results = connection.execute(stmt).fetchall()
   print("results", results)
   if len(results) > 0:
      for row in results:
         if len(row) > 0:
            print(row[0])
            print("User found in database.!")
         else:
            print("User not found in database.!")
   else:
      print("There are no users found in db with username : GiriCasd")

if __name__ == "__main__":
    main()

"""
