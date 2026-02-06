require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 COCO Backend running on http://localhost:${PORT}`);
  console.log(`✅ Ready to receive chat requests`);
});