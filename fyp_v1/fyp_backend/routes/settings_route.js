const router = require("express").Router();
const settingsController = require("../controllers/settings_controller");
const { verifyAdmin } = require("../middlewares/varifyTokens");

router.get("/", settingsController.getSettings);
router.put("/", verifyAdmin, settingsController.updateSettings);

module.exports = router;
