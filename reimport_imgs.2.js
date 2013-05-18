// images collection -> pioneers collection
// mongo localhost/stdb_dev ./reimport_imgs.js

idlast = db.users.findOne({name:"IDLast.com"});

pioneers = db.images.find({pioneer: true});null;

while (pioneers.hasNext())
{
	pioneer = pioneers.next();
	new_pioneer = {};
	new_pioneer.img_id = pioneer._id;
	new_pioneer.type = "vector";
	new_pioneer.approved = true;
	new_pioneer.user_id = idlast._id;
	new_pioneer.user_name = idlast.name;
	new_pioneer.created_at = pioneer.found;
	new_pioneer.approved_at = pioneer.approved;
	db.pioneers.insert(new_pioneer);
}