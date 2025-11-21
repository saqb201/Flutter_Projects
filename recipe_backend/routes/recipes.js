import express from 'express';
import Recipe from '../models/Recipe.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

// @desc    Add recipe to favorites
// @route   POST /api/recipes/favorites
// @access  Private
router.post('/favorites', protect, async (req, res) => {
  try {
    const recipeData = {
      ...req.body,
      userId: req.user._id
    };

    const recipe = await Recipe.create(recipeData);

    res.status(201).json({
      success: true,
      data: recipe
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({
        success: false,
        message: 'Recipe already in favorites'
      });
    }
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// @desc    Get user's favorite recipes
// @route   GET /api/recipes/favorites
// @access  Private
router.get('/favorites', protect, async (req, res) => {
  try {
    const recipes = await Recipe.find({ userId: req.user._id });
    
    res.json({
      success: true,
      data: recipes
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// @desc    Remove recipe from favorites
// @route   DELETE /api/recipes/favorites/:mealId
// @access  Private
router.delete('/favorites/:mealId', protect, async (req, res) => {
  try {
    await Recipe.findOneAndDelete({ 
      mealId: req.params.mealId, 
      userId: req.user._id 
    });

    res.json({
      success: true,
      message: 'Recipe removed from favorites'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// @desc    Check if recipe is favorite
// @route   GET /api/recipes/favorites/check/:mealId
// @access  Private
router.get('/favorites/check/:mealId', protect, async (req, res) => {
  try {
    const recipe = await Recipe.findOne({ 
      mealId: req.params.mealId, 
      userId: req.user._id 
    });

    res.json({
      success: true,
      isFavorite: !!recipe
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

export default router;