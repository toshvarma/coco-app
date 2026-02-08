require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// In-memory user accounts
const users = {
  'lena@coco.com': {
    password: 'password1',
    name: 'Lena Hoffman',
    scheduledPosts: []
  },
  'mike@coco.com': {
    password: 'password2',
    name: 'Mike Murga',
    scheduledPosts: []
  }
};

app.get('/health', (req, res) => {
  res.json({ status: 'Server is running!' });
});

// Login endpoint
app.post('/api/auth/login', (req, res) => {
  try {
    const { email, password } = req.body;

    console.log('🔐 Login attempt for:', email);

    if (users[email] && users[email].password === password) {
      res.json({
        success: true,
        user: {
          email: email,
          name: users[email].name
        }
      });
    } else {
      res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      });
    }
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

app.post('/api/chat', async (req, res) => {
  try {
    const { messages, system, userEmail } = req.body;

    console.log('Received chat request');

    // Get user's name for personalization
    const userName = users[userEmail]?.name || 'there';
    const personalizedSystem = system.replace('You are COCO', `You are COCO, speaking to ${userName}`);

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
        system: personalizedSystem || `You are COCO, a helpful AI assistant for social media content creation speaking to ${userName}.`,
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

// Schedule a post (user-specific)
app.post('/api/posts/schedule', (req, res) => {
  try {
    const { userEmail, post } = req.body;

    console.log('📝 Scheduling new post for:', userEmail);

    if (!users[userEmail]) {
      return res.status(404).json({
        success: false,
        error: 'User not found'
      });
    }

    users[userEmail].scheduledPosts.push(post);

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

// Get all scheduled posts (user-specific)
app.get('/api/posts/scheduled/:userEmail', (req, res) => {
  try {
    const { userEmail } = req.params;

    console.log('📅 Fetching scheduled posts for:', userEmail);

    if (!users[userEmail]) {
      return res.status(404).json({
        success: false,
        error: 'User not found'
      });
    }

    res.json({
      success: true,
      posts: users[userEmail].scheduledPosts
    });
  } catch (error) {
    console.error('Error fetching posts:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Delete a scheduled post (user-specific)
app.delete('/api/posts/scheduled/:userEmail/:id', (req, res) => {
  try {
    const { userEmail, id } = req.params;

    console.log('🗑️ Deleting post:', id, 'for user:', userEmail);

    if (!users[userEmail]) {
      return res.status(404).json({
        success: false,
        error: 'User not found'
      });
    }

    users[userEmail].scheduledPosts = users[userEmail].scheduledPosts.filter(
      post => post.id !== id
    );

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
  console.log(`👥 Available accounts:`);
  console.log(`   - lena@coco.com / password1 (Lena Hoffman)`);
  console.log(`   - mike@coco.com / password2 (Mike Murga)`);
});