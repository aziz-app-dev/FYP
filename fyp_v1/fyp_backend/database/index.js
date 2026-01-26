
const mongoose = require('mongoose');
const { MONGO_URL } = require('../config/index');

const dbConnect = async () => {
  try {
    await mongoose.connect(MONGO_URL, {

    });

    console.log(`Database connected to localhost: ${mongoose.connection.host}`);
  } catch (error) {
    console.log(`Error: ${error}`);
  }
};

module.exports = dbConnect;
