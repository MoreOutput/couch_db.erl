couch_db.erl
=======

Erlang module using httpc to make calls to CouchDBs REST api and provide simple consistent output. 

Nothing fancy here:

```erlang
	c("couch_db").
	couch_db:get("http://localhost:5984/DATABASE", "root", "").
	couch_db:put("http://localhost:5984/NEWDATABASE", "root", "").
	couch_db:post("http://localhost:5984/DATABASE", 
		"{\"fullName\": \"Homer Simpson\"}", "root", "").
```

All calls require auth information. You can expect back the following:

```erlang
	{[
		{url, Query}, %% URL you just requested
		{status, Status}, %% HTTP response code
		{auth, Authorization}, %% Auth status
		{data, CouchResponse} %% The direct response from CouchDB
	]}
```
