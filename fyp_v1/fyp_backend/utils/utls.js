function generateOtp(){
    const opt =Math.floor(100000+Math.random()* 900000);
    return opt.toString().substring(0,6);
}

module.exports =generateOtp;