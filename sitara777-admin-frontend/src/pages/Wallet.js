import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Box,
  TextField,
  Button,
  Card,
  CardContent,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  CircularProgress,
  Chip,
  Tabs,
  Tab,
} from '@mui/material';
import {
  Search as SearchIcon,
  Add as AddIcon,
  Remove as RemoveIcon,
} from '@mui/icons-material';

const Wallet = () => {
  const [tabValue, setTabValue] = useState(0);
  const [users, setUsers] = useState([]);
  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [formData, setFormData] = useState({
    amount: '',
    type: 'credit',
    description: '',
  });

  // Simulate fetching data
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Mock users data
        const mockUsers = [
          {
            uid: '1',
            profile: {
              name: 'John Doe',
              phone: '+91 9876543210',
            },
            wallet: {
              balance: 1500.00,
              totalDeposited: 5000.00,
              totalWithdrawn: 2000.00,
              totalWinnings: 3000.00,
              totalLosses: 1000.00,
            },
          },
          {
            uid: '2',
            profile: {
              name: 'Jane Smith',
              phone: '+91 9876543211',
            },
            wallet: {
              balance: 2500.00,
              totalDeposited: 7000.00,
              totalWithdrawn: 3000.00,
              totalWinnings: 4000.00,
              totalLosses: 1500.00,
            },
          },
        ];
        
        // Mock transactions data
        const mockTransactions = [
          {
            id: '1',
            userId: '1',
            userName: 'John Doe',
            type: 'recharge',
            amount: 1000.00,
            description: 'UPI Payment',
            createdAt: new Date('2023-09-15T10:30:00'),
            status: 'completed',
          },
          {
            id: '2',
            userId: '1',
            userName: 'John Doe',
            type: 'bet_placed',
            amount: 100.00,
            description: 'Bet on Mumbai Main',
            createdAt: new Date('2023-09-15T11:15:00'),
            status: 'completed',
          },
          {
            id: '3',
            userId: '2',
            userName: 'Jane Smith',
            type: 'bet_won',
            amount: 2000.00,
            description: 'Winning bet on Delhi King',
            createdAt: new Date('2023-09-15T12:00:00'),
            status: 'completed',
          },
        ];
        
        setUsers(mockUsers);
        setTransactions(mockTransactions);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const handleSearch = (e) => {
    setSearch(e.target.value);
  };

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleAddCoins = (user) => {
    setSelectedUser(user);
    setFormData({
      amount: '',
      type: 'credit',
      description: '',
    });
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedUser(null);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle form submission
    handleCloseDialog();
  };

  const getTypeChip = (type) => {
    switch (type) {
      case 'recharge':
        return <Chip label="Recharge" color="primary" size="small" />;
      case 'withdrawal':
        return <Chip label="Withdrawal" color="warning" size="small" />;
      case 'bet_placed':
        return <Chip label="Bet Placed" color="info" size="small" />;
      case 'bet_won':
        return <Chip label="Bet Won" color="success" size="small" />;
      case 'bet_lost':
        return <Chip label="Bet Lost" color="error" size="small" />;
      case 'admin_credit':
        return <Chip label="Admin Credit" color="success" size="small" />;
      case 'admin_debit':
        return <Chip label="Admin Debit" color="error" size="small" />;
      default:
        return <Chip label={type} size="small" />;
    }
  };

  const filteredUsers = users.filter(user => 
    user.profile.name.toLowerCase().includes(search.toLowerCase()) ||
    user.profile.phone.includes(search)
  );

  const filteredTransactions = transactions.filter(transaction => 
    transaction.userName.toLowerCase().includes(search.toLowerCase()) ||
    transaction.description.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Typography variant="h4" gutterBottom>
        Wallet Management
      </Typography>

      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box display="flex" alignItems="center">
            <TextField
              fullWidth
              variant="outlined"
              placeholder="Search users or transactions..."
              value={search}
              onChange={handleSearch}
              InputProps={{
                startAdornment: <SearchIcon sx={{ mr: 1, color: 'gray' }} />,
              }}
            />
          </Box>
        </CardContent>
      </Card>

      <Card>
        <Tabs value={tabValue} onChange={handleTabChange} sx={{ borderBottom: 1, borderColor: 'divider' }}>
          <Tab label="User Wallets" />
          <Tab label="Transaction History" />
        </Tabs>
        
        <CardContent>
          {loading ? (
            <Box display="flex" justifyContent="center" my={4}>
              <CircularProgress />
            </Box>
          ) : tabValue === 0 ? (
            // User Wallets Tab
            <TableContainer component={Paper}>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>User</TableCell>
                    <TableCell>Phone</TableCell>
                    <TableCell>Balance</TableCell>
                    <TableCell>Total Deposited</TableCell>
                    <TableCell>Total Withdrawn</TableCell>
                    <TableCell>Total Winnings</TableCell>
                    <TableCell>Total Losses</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredUsers.map((user) => (
                    <TableRow key={user.uid}>
                      <TableCell>{user.profile.name}</TableCell>
                      <TableCell>{user.profile.phone}</TableCell>
                      <TableCell>₹{user.wallet.balance.toFixed(2)}</TableCell>
                      <TableCell>₹{user.wallet.totalDeposited.toFixed(2)}</TableCell>
                      <TableCell>₹{user.wallet.totalWithdrawn.toFixed(2)}</TableCell>
                      <TableCell>₹{user.wallet.totalWinnings.toFixed(2)}</TableCell>
                      <TableCell>₹{user.wallet.totalLosses.toFixed(2)}</TableCell>
                      <TableCell>
                        <IconButton 
                          color="success" 
                          onClick={() => handleAddCoins(user)}
                          title="Add Coins"
                        >
                          <AddIcon />
                        </IconButton>
                        <IconButton 
                          color="error" 
                          onClick={() => handleAddCoins({...user, isDebit: true})}
                          title="Deduct Coins"
                        >
                          <RemoveIcon />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          ) : (
            // Transaction History Tab
            <TableContainer component={Paper}>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>User</TableCell>
                    <TableCell>Type</TableCell>
                    <TableCell>Amount</TableCell>
                    <TableCell>Description</TableCell>
                    <TableCell>Date</TableCell>
                    <TableCell>Status</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredTransactions.map((transaction) => (
                    <TableRow key={transaction.id}>
                      <TableCell>{transaction.userName}</TableCell>
                      <TableCell>{getTypeChip(transaction.type)}</TableCell>
                      <TableCell>₹{transaction.amount.toFixed(2)}</TableCell>
                      <TableCell>{transaction.description}</TableCell>
                      <TableCell>
                        {transaction.createdAt.toLocaleDateString()} {transaction.createdAt.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
                      </TableCell>
                      <TableCell>
                        <Chip 
                          label={transaction.status} 
                          color={transaction.status === 'completed' ? 'success' : 'warning'} 
                          size="small" 
                        />
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          )}
        </CardContent>
      </Card>

      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
        <DialogTitle>
          {selectedUser?.isDebit ? 'Deduct Coins' : 'Add Coins'}
        </DialogTitle>
        <DialogContent>
          <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1 }}>
            <Typography variant="h6" gutterBottom>
              {selectedUser?.profile?.name}
            </Typography>
            <Typography variant="body2" color="textSecondary" gutterBottom>
              Current Balance: ₹{selectedUser?.wallet?.balance?.toFixed(2)}
            </Typography>
            
            <FormControl fullWidth margin="dense">
              <InputLabel>Type</InputLabel>
              <Select
                value={formData.type}
                label="Type"
                onChange={(e) => setFormData({...formData, type: e.target.value})}
              >
                <MenuItem value="credit">Credit</MenuItem>
                <MenuItem value="debit">Debit</MenuItem>
              </Select>
            </FormControl>
            
            <TextField
              autoFocus
              margin="dense"
              name="amount"
              label="Amount"
              type="number"
              fullWidth
              variant="outlined"
              value={formData.amount}
              onChange={(e) => setFormData({...formData, amount: e.target.value})}
              required
            />
            
            <TextField
              margin="dense"
              name="description"
              label="Description"
              type="text"
              fullWidth
              variant="outlined"
              multiline
              rows={3}
              value={formData.description}
              onChange={(e) => setFormData({...formData, description: e.target.value})}
              required
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            {selectedUser?.isDebit ? 'Deduct' : 'Add'}
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default Wallet;