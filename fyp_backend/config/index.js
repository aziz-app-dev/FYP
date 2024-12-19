const dotenv = require("dotenv").config();

const PORT=process.env.PORT;
const MONGO_URL=process.env.MONGO_URL
const SECRET=process.env.SECRET
const JWT_SEC=process.env.JWT_SEC
const PASSWORD=process.env.PASSWORD
const EMAIL=process.env.EMAIL

module.exports={
    PORT,
    MONGO_URL,
    JWT_SEC,
    SECRET,
    PASSWORD,
    EMAIL
}