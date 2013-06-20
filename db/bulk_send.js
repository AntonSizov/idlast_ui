
users = db.users.find({"articles_notify":true});null;

while (users.hasNext())
{
	user = users.next();
	string = user.name + ";" + user.email;
	print(string);
}