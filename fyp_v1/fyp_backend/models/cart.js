const mongoose = require('mongoose');

const cartSchema = new mongoose.Schema({
    userId:{type:mongoose.Schema.Types.ObjectId, ref:'User'},
    productId:{type:mongoose.Schema.Types.ObjectId, ref:'Food'},
    additives:{type:Array, require:false, default:[]},
    instructions:{type:String, default:''},
    quantity:{type:Number,require:true,},
    totalPrice:{type:Number, require:true},
});

module.exports = mongoose.model('Cart', cartSchema);
