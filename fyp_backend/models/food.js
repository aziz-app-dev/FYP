const mongoose=require('mongoose');

const foodSchema=new mongoose.Schema({
    title:{type:String, required:true},
    time:{type:String, required:true},
    description:{type:String, required:true},
    foodTags:{type:Array, required:true},
    foodType:{type:Array, required:true},
    category:{type:String, required:true},
    code:{type:String, required:true},
    isAvailable:{type:Boolean, required:true,default:true},
    restaurant:{type:mongoose.SchemaTypes.ObjectId, ref:"Restaurantes"},
    rating:{
        type:Number, min:1,max:5
    },

    ratingCount:{type:String},
    price:{type:Number, required:true},
    additives:{type:Array, required:true},
    imageUrl:{type:Array,required:true},
},
{timestamps:false},
);

module.exports = mongoose.model("Food",foodSchema);