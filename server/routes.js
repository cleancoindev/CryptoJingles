const router = require('express').Router();

require('./models/jingles.model');
const jingleCtrl = require('./controllers/jingles.controller');

router.get('/jingles/:owner/page/:page/filter/:filter', jingleCtrl.getJinglesForOwner);
router.get('/jingle/:jingleId', jingleCtrl.getJingle);
router.get('/jingles/pagination/:page/filter/:filter', jingleCtrl.getJingles);
router.get('/jingles/sale/:page/filter/:filter', jingleCtrl.getJinglesForSale);
router.get('/jingles/count/filter/:filter/sale/:sale', jingleCtrl.getJingleNum);

module.exports = router;