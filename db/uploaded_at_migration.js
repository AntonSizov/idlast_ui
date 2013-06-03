
pioneers = db.pioneers.find({uploaded_at:{$exists:false}});null;

while (pioneers.hasNext())
{
	pioneer = pioneers.next();
	db.pioneers.update({_id:pioneer._id}, {$set:{uploaded_at:pioneer.created_at}});
}