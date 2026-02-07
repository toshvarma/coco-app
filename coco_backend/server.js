require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// In-memory storage for scheduled posts (resets when server restarts)
let scheduledPosts = [];

app.get('/health', (req, res) => {
  res.json({ status: 'Server is running!' });
});

app.post('/api/chat', async (req, res) => {
  try {
    const { messages, system } = req.body;

    console.log('Received chat request');

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': process.env.ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01',
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-5-20250929',
        max_tokens: 1024,
        messages: messages,
        system: system || 'You are COCO, a helpful AI assistant for social media content creation.',
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      console.error('Anthropic API error:', data);
      throw new Error(data.error?.message || 'API request failed');
    }

    console.log('Successfully got AI response');
    res.json(data);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).json({
      error: 'Failed to get AI response',
      message: error.message
    });
  }
});

// NEW: Schedule a post
app.post('/api/posts/schedule', (req, res) => {
  try {
    console.log('📝 Scheduling new post:', req.body);

    const post = req.body;
    scheduledPosts.push(post);

    res.json({
      success: true,
      message: 'Post scheduled successfully',
      post: post
    });
  } catch (error) {
    console.error('Error scheduling post:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// NEW: Get all scheduled posts
app.get('/api/posts/scheduled', (req, res) => {
  try {
    console.log('📅 Fetching all scheduled posts');
    res.json({
      success: true,
      posts: scheduledPosts
    });
  } catch (error) {
    console.error('Error fetching posts:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// NEW: Delete a scheduled post
app.delete('/api/posts/scheduled/:id', (req, res) => {
  try {
    const { id } = req.params;
    console.log('🗑️ Deleting post:', id);

    scheduledPosts = scheduledPosts.filter(post => post.id !== id);

    res.json({
      success: true,
      message: 'Post deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting post:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 COCO Backend running on http://localhost:${PORT}`);
  console.log(`✅ Ready to receive chat requests`);
});