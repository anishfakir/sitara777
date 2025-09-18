import React, { useState, useEffect } from 'react';
import {
  Container,
  Grid,
  Card,
  CardContent,
  Typography,
  Box,
  CircularProgress,
} from '@mui/material';
import {
  People as PeopleIcon,
  SportsEsports as GamesIcon,
  AccountBalanceWallet as WalletIcon,
  Payment as PaymentIcon,
  SportsBet as BetIcon,
} from '@mui/icons-material';

const Dashboard = () => {
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    users: { total: 0, active: 0 },
    games: { total: 0, active: 0 },
    payments: { pending: 0 },
    bets: { pending: 0 },
    wallet: { totalBalance: 0, totalDeposited: 0, totalWithdrawn: 0 },
  });

  useEffect(() => {
    // Simulate fetching dashboard stats
    const fetchStats = async () => {
      setLoading(true);
      try {
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Mock data
        setStats({
          users: { total: 1242, active: 856 },
          games: { total: 24, active: 18 },
          payments: { pending: 23 },
          bets: { pending: 156 },
          wallet: { totalBalance: 125000, totalDeposited: 450000, totalWithdrawn: 325000 },
        });
      } catch (error) {
        console.error('Error fetching stats:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchStats();
  }, []);

  const StatCard = ({ title, value, icon, color }) => (
    <Card>
      <CardContent>
        <Box display="flex" alignItems="center">
          <Box sx={{ color: color, mr: 2 }}>{icon}</Box>
          <Box>
            <Typography variant="h6" component="div">
              {title}
            </Typography>
            <Typography variant="h4" component="div" sx={{ fontWeight: 'bold' }}>
              {value}
            </Typography>
          </Box>
        </Box>
      </CardContent>
    </Card>
  );

  if (loading) {
    return (
      <Container sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
        <CircularProgress />
      </Container>
    );
  }

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Typography variant="h4" gutterBottom>
        Dashboard
      </Typography>
      
      <Grid container spacing={3}>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard 
            title="Total Users" 
            value={stats.users.total} 
            icon={<PeopleIcon />} 
            color="#1976d2" 
          />
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <StatCard 
            title="Active Games" 
            value={stats.games.active} 
            icon={<GamesIcon />} 
            color="#4caf50" 
          />
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <StatCard 
            title="Pending Payments" 
            value={stats.payments.pending} 
            icon={<PaymentIcon />} 
            color="#ff9800" 
          />
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <StatCard 
            title="Pending Bets" 
            value={stats.bets.pending} 
            icon={<BetIcon />} 
            color="#f44336" 
          />
        </Grid>
        
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Wallet Overview
              </Typography>
              <Typography variant="body1">
                Total Balance: ₹{stats.wallet.totalBalance.toLocaleString()}
              </Typography>
              <Typography variant="body1">
                Total Deposited: ₹{stats.wallet.totalDeposited.toLocaleString()}
              </Typography>
              <Typography variant="body1">
                Total Withdrawn: ₹{stats.wallet.totalWithdrawn.toLocaleString()}
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Recent Activity
              </Typography>
              <Typography variant="body2" color="text.secondary">
                No recent activity to display.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Dashboard;