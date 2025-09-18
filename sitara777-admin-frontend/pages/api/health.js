// Render requires a health check endpoint for static sites
// This file will be used by Render to check if the frontend is alive

export const config = {
  api: {
    externalResolver: true,
  },
}

export default function handler(req, res) {
  res.status(200).json({ status: 'ok', timestamp: new Date().toISOString() })
}