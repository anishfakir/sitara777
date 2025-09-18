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
  Check as CheckIcon,
  Close as CloseIcon,
} from '@mui/icons-material';

const Payments = () => {
  const [tabValue, setTabValue] = useState(0);
  const [recharges, setRecharges] = useState([]);
  const [withdrawals, setWithdrawals] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');

  // Simulate fetching payments
  useEffect(() => {
    const fetchPayments = async () => {
      setLoading(true);
      try {
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Mock recharges data
        const mockRecharges = [
          {
            id: '1',
            userId: 'user1',
            userName: 'John Doe',
            userPhone: '+91 9876543210',
            amount: 1000.00,
            paymentMethod: 'UPI',
            transactionId: 'TXN123456789',
            status: 'pending',
            createdAt: new Date('2023-09-15T10:30:00'),
          },
          {
            id: '2',
            userId: 'user2',
            userName: 'Jane Smith',
            userPhone: '+91 9876543211',
            amount: 500.00,
            paymentMethod: 'Paytm',
            transactionId: 'TXN987654321',
            status: 'approved',
            createdAt: new Date('2023-09-14T11:15:00'),
          },
          {
            id: '3',
            userId: 'user3',
            userName: 'Robert Johnson',
            userPhone: '+91 9876543212',
            amount: 2000.00,
            paymentMethod: 'Bank Transfer',
            transactionId: 'TXN456789123',
            status: 'rejected',
            createdAt: new Date('2023-09-13T12:00:00'),
          },
        ];
        
        // Mock withdrawals data
        const mockWithdrawals = [
          {
            id: '1',
            userId: 'user1',
            userName: 'John Doe',
            userPhone: '+91 9876543210',
            amount: 500.00,
            withdrawalMethod: 'UPI',
            accountDetails: {
              upiId: 'john@upi',
            },
            status: 'pending',
            requestedAt: new Date('2023-09-15T10:30:00'),
          },
          {
            id: '2',
            userId: 'user2',
            userName: 'Jane Smith',
            userPhone: '+91 9876543211',
            amount: 1000.00,
            withdrawalMethod: 'Bank Transfer',
            accountDetails: {
              accountNumber: '1234567890',
              ifscCode: 'BANK0001234',
              accountHolderName: 'Jane Smith',
            },
            status: 'processed',
            requestedAt: new Date('2023-09-14T11:15:00'),
          },
        ];
        
        setRecharges(mockRecharges);
        setWithdrawals(mockWithdrawals);
      } catch (error) {
        console.error('Error fetching payments:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchPayments();
  }, []);

  const handleSearch = (e) => {
    setSearch(e.target.value);
  };

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleApproveRecharge = (rechargeId) => {
    setRecharges(recharges.map(recharge => 
      recharge.id === rechargeId ? {...recharge, status: 'approved'} : recharge
    ));
  };

  const handleRejectRecharge = (rechargeId) => {
    setRecharges(recharges.map(recharge => 
      recharge.id === rechargeId ? {...recharge, status: 'rejected'} : recharge
    ));
  };

  const handleApproveWithdrawal = (withdrawalId) => {
    setWithdrawals(withdrawals.map(withdrawal => 
      withdrawal.id === withdrawalId ? {...withdrawal, status: 'processed'} : withdrawal
    ));
  };

  const handleRejectWithdrawal = (withdrawalId) => {
    setWithdrawals(withdrawals.map(withdrawal => 
      withdrawal.id === withdrawalId ? {...withdrawal, status: 'rejected'} : withdrawal
    ));
  };

  const getStatusChip = (status) => {
    switch (status) {
      case 'pending':
        return <Chip label="Pending" color="warning" size="small" />;
      case 'approved':
        return <Chip label="Approved" color="success" size="small" />;
      case 'rejected':
        return <Chip label="Rejected" color="error" size="small" />;
      case 'processed':
        return <Chip label="Processed" color="success" size="small" />;
      default:
        return <Chip label={status} size="small" />;
    }
  };

  const filteredRecharges = recharges.filter(recharge => 
    recharge.userName.toLowerCase().includes(search.toLowerCase()) ||
    recharge.userPhone.includes(search) ||
    recharge.transactionId.toLowerCase().includes(search.toLowerCase())
  );

  const filteredWithdrawals = withdrawals.filter(withdrawal => 
    withdrawal.userName.toLowerCase().includes(search.toLowerCase()) ||
    withdrawal.userPhone.includes(search) ||
    (withdrawal.accountDetails.upiId && withdrawal.accountDetails.upiId.includes(search))
  );

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Typography variant="h4" gutterBottom>
        Payment Management
      </Typography>

      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box display="flex" gap={2} alignItems="center" flexWrap="wrap">
            <TextField
              variant="outlined"
              placeholder="Search payments..."
              value={search}
              onChange={handleSearch}
              InputProps={{
                startAdornment: <SearchIcon sx={{ mr: 1, color: 'gray' }} />,
              }}
              sx={{ flex: 1, minWidth: 200 }}
            />
          </Box>
        </CardContent>
      </Card>

      <Card>
        <Tabs value={tabValue} onChange={handleTabChange} sx={{ borderBottom: 1, borderColor: 'divider' }}>
          <Tab label="Recharge Requests" />
          <Tab label="Withdrawal Requests" />
        </Tabs>
        
        <CardContent>
          {loading ? (
            <Box display="flex" justifyContent="center" my={4}>
              <CircularProgress />
            </Box>
          ) : tabValue === 0 ? (
            // Recharge Requests Tab
            <TableContainer component={Paper}>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>User</TableCell>
                    <TableCell>Phone</TableCell>
                    <TableCell>Amount</TableCell>
                    <TableCell>Payment Method</TableCell>
                    <TableCell>Transaction ID</TableCell>
                    <TableCell>Requested At</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredRecharges.map((recharge) => (
                    <TableRow key={recharge.id}>
                      <TableCell>{recharge.userName}</TableCell>
                      <TableCell>{recharge.userPhone}</TableCell>
                      <TableCell>₹{recharge.amount.toFixed(2)}</TableCell>
                      <TableCell>{recharge.paymentMethod}</TableCell>
                      <TableCell>{recharge.transactionId}</TableCell>
                      <TableCell>
                        {recharge.createdAt.toLocaleDateString()} {recharge.createdAt.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
                      </TableCell>
                      <TableCell>{getStatusChip(recharge.status)}</TableCell>
                      <TableCell>
                        {recharge.status === 'pending' && (
                          <>
                            <IconButton 
                              color="success" 
                              onClick={() => handleApproveRecharge(recharge.id)}
                              title="Approve"
                            >
                              <CheckIcon />
                            </IconButton>
                            <IconButton 
                              color="error" 
                              onClick={() => handleRejectRecharge(recharge.id)}
                              title="Reject"
                            >
                              <CloseIcon />
                            </IconButton>
                          </>
                        )}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          ) : (
            // Withdrawal Requests Tab
            <TableContainer component={Paper}>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>User</TableCell>
                    <TableCell>Phone</TableCell>
                    <TableCell>Amount</TableCell>
                    <TableCell>Method</TableCell>
                    <TableCell>Details</TableCell>
                    <TableCell>Requested At</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredWithdrawals.map((withdrawal) => (
                    <TableRow key={withdrawal.id}>
                      <TableCell>{withdrawal.userName}</TableCell>
                      <TableCell>{withdrawal.userPhone}</TableCell>
                      <TableCell>₹{withdrawal.amount.toFixed(2)}</TableCell>
                      <TableCell>{withdrawal.withdrawalMethod}</TableCell>
                      <TableCell>
                        {withdrawal.accountDetails.upiId ? 
                          `UPI: ${withdrawal.accountDetails.upiId}` : 
                          `Bank: ${withdrawal.accountDetails.accountHolderName}`
                        }
                      </TableCell>
                      <TableCell>
                        {withdrawal.requestedAt.toLocaleDateString()} {withdrawal.requestedAt.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
                      </TableCell>
                      <TableCell>{getStatusChip(withdrawal.status)}</TableCell>
                      <TableCell>
                        {withdrawal.status === 'pending' && (
                          <>
                            <IconButton 
                              color="success" 
                              onClick={() => handleApproveWithdrawal(withdrawal.id)}
                              title="Approve"
                            >
                              <CheckIcon />
                            </IconButton>
                            <IconButton 
                              color="error" 
                              onClick={() => handleRejectWithdrawal(withdrawal.id)}
                              title="Reject"
                            >
                              <CloseIcon />
                            </IconButton>
                          </>
                        )}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          )}
        </CardContent>
      </Card>
    </Container>
  );
};

export default Payments;