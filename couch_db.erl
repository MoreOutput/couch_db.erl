-module(couch_db).
-export([get/3, post/4, put/4, delete/3]).

%% URL being something like http://localhost:5984/DATABASE
%% couch_db:get("http://localhost:5984/DATABASE/_design/clients/_view/clients", "root", "").
%% couch_db:post("http://localhost:5984/DATABASE", "{\"username\": \"Homer Simpson\"}", "root", "")
auth_header(User, Password) ->
 	Encoded = base64:encode_to_string(lists:append([User, ":", Password])),
    {"Authorization", "Basic " ++ Encoded}.

get(URL, User, Password) ->
	HttpResponse = httpc:request(get, {URL, [auth_header(User, Password)]}, [], []),
	{_, {{_,Status, Authorization}, _, CouchResponse}} = HttpResponse,
	to_response(URL, Status, Authorization, CouchResponse).

post(URL, JsonString, User, Password) ->
	HttpResponse = httpc:request(post, {URL, [auth_header(User, Password)], "application/json; charset=UTF-8", JsonString}, [], []),
	{_, {{_,Status, Authorization}, _, CouchResponse}} = HttpResponse,
	to_response(URL, Status, Authorization, CouchResponse).

put(URL, User, Password) ->
	HttpResponse = httpc:request(put, {URL, [auth_header(User, Password)], "application/json; charset=UTF-8", ""}, [], []),
	{_, {{_,Status, Authorization}, _, CouchResponse}} = HttpResponse,
	to_response(URL, Status, Authorization, CouchResponse).

delete(URL, User, Password) ->
	HttpResponse = httpc:request(delete, {URL, [auth_header(User, Password)]}, [], []),
	{_, {{_,Status, Authorization}, _, CouchResponse}} = HttpResponse,
	to_response(URL, Status, Authorization, CouchResponse).

to_response(Query, Status, Authorization, CouchResponse) ->
	Message = {[
		{url, Query},
		{status, Status},
		{auth, Authorization},
		{data, CouchResponse}
	]},
	%% io:format("~p", [Message]),
	Message.