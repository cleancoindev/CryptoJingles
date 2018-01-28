const mongoose = require('mongoose');
const Jingle = mongoose.model('Jingle');

module.exports.getJinglesForOwner = async (req, res) => {
    try {
        const jingles = await Jingle.find({owner: req.params.owner});

        console.log(jingles);

        res.status(200);
        res.json(jingles);

    } catch(err) {
        console.log(err);
    }
}

module.exports.getJingle = async (req, res) => {
    try {
        const jingleId = req.params.jingleId;

        const jingle = await Jingle.find({jingleId: jingleId});

        console.log(jingle);

        res.status(200);
        res.json(jingle);

    } catch(err) {
        console.log(err);
    }
}

// Server only method not exposed in api
module.exports.addJingle = async (jingleData) => {
    try {
        const jingle = new Jingle(jingleData);

        await jingle.save();

        return true;

    } catch(err) {
        console.log(err);
        return false;
    }
}