const express = require("express")
const router = express.Router()
const multer = require("multer")
const path = require("path")
const Image = require("../models/image.model.js")

// Configure storage for Multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});

const upload = multer({ storage });

router.use('/', express.static(path.join(__dirname, 'uploads')));

router.post('/', upload.single('image'), async (req, res) => {
  if (req.file) {
    const image = new Image({
      path: req.file.path,
      originalName: req.file.originalname
    });
    await image.save();
    res.status(201).json(image);
  } else {
    res.status(400).json({ error: 'No file uploaded' });
  }
});

router.get('/:imageId', async (req, res) => {
  try {
    const image = await Image.findById(req.params.imageId);
    if (image) {
      // Send the image file
      res.sendFile(path.resolve(image.path));
    } else {
      res.status(404).json({ error: 'Image not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router