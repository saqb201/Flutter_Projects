import mongoose from 'mongoose';

const recipeSchema = new mongoose.Schema({
  mealId: {
    type: String,
    required: true
  },
  mealName: {
    type: String,
    required: true
  },
  category: String,
  area: String,
  instructions: String,
  imageUrl: String,
  youtubeUrl: String,
  sourceUrl: String,
  ingredients: [String],
  measures: [String],
  tags: [String],
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  }
}, {
  timestamps: true
});

// Compound index for user and mealId to prevent duplicates
recipeSchema.index({ userId: 1, mealId: 1 }, { unique: true });

export default mongoose.model('Recipe', recipeSchema);