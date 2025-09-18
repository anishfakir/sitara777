import React, { useState } from 'react';
import {
  Container,
  Typography,
  Box,
  TextField,
  Button,
  Card,
  CardContent,
  Avatar,
  Divider,
} from '@mui/material';
import { AccountCircle as AccountIcon } from '@mui/icons-material';

const Profile = () => {
  const [formData, setFormData] = useState({
    name: 'Admin User',
    email: 'admin@sitara777.com',
    phone: '+91 9876543210',
    currentPassword: '',
    newPassword: '',
    confirmNewPassword: '',
  });

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle form submission
    alert('Profile updated successfully!');
  };

  const handlePasswordChange = (e) => {
    e.preventDefault();
    // Handle password change
    if (formData.newPassword !== formData.confirmNewPassword) {
      alert('New passwords do not match!');
      return;
    }
    alert('Password updated successfully!');
  };

  return (
    <Container maxWidth="md" sx={{ mt: 4, mb: 4 }}>
      <Typography variant="h4" gutterBottom>
        My Profile
      </Typography>

      <Card>
        <CardContent>
          <Box display="flex" flexDirection="column" alignItems="center" mb={3}>
            <Avatar sx={{ width: 100, height: 100, mb: 2 }}>
              <AccountIcon sx={{ fontSize: 60 }} />
            </Avatar>
            <Typography variant="h6">{formData.name}</Typography>
            <Typography variant="body2" color="textSecondary">
              Administrator
            </Typography>
          </Box>

          <Divider sx={{ mb: 3 }} />

          <Box component="form" onSubmit={handleSubmit}>
            <Typography variant="h6" gutterBottom>
              Personal Information
            </Typography>
            
            <TextField
              fullWidth
              margin="normal"
              label="Name"
              name="name"
              value={formData.name}
              onChange={handleChange}
              required
            />
            
            <TextField
              fullWidth
              margin="normal"
              label="Email"
              name="email"
              type="email"
              value={formData.email}
              onChange={handleChange}
              required
            />
            
            <TextField
              fullWidth
              margin="normal"
              label="Phone"
              name="phone"
              value={formData.phone}
              onChange={handleChange}
            />
            
            <Box sx={{ mt: 2 }}>
              <Button variant="contained" type="submit">
                Update Profile
              </Button>
            </Box>
          </Box>

          <Divider sx={{ my: 3 }} />

          <Box component="form" onSubmit={handlePasswordChange}>
            <Typography variant="h6" gutterBottom>
              Change Password
            </Typography>
            
            <TextField
              fullWidth
              margin="normal"
              label="Current Password"
              name="currentPassword"
              type="password"
              value={formData.currentPassword}
              onChange={handleChange}
              required
            />
            
            <TextField
              fullWidth
              margin="normal"
              label="New Password"
              name="newPassword"
              type="password"
              value={formData.newPassword}
              onChange={handleChange}
              required
            />
            
            <TextField
              fullWidth
              margin="normal"
              label="Confirm New Password"
              name="confirmNewPassword"
              type="password"
              value={formData.confirmNewPassword}
              onChange={handleChange}
              required
            />
            
            <Box sx={{ mt: 2 }}>
              <Button variant="contained" type="submit">
                Change Password
              </Button>
            </Box>
          </Box>
        </CardContent>
      </Card>
    </Container>
  );
};

export default Profile;