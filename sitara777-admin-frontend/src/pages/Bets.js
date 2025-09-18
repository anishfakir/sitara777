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
} from '@mui/material';
import {
  Search as SearchIcon,
  Check as CheckIcon,
  Close as CloseIcon,
  Cancel as CancelIcon,
} from '@mui/icons-material';

const Bets = () => {
  const [bets, setBets] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedBet, setSelectedBet] = useState(null);

  // Simulate fetching bets
  useEffect(() => {
    const fetchBets = async () => {
      setLoading(true);
      try {
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Mock data
        const mockBets = [
          {
            id: '1',
            userId: 'user1',
            gameId: 'game1',
            gameName: 'Mumbai Main',
            betTypeId: 'single',
            betTypeName: 'Single',
            amount: 100.00,
            betNumber: '5',
            placedAt: new Date('2023-09-15T10:30:00'),
            status: 'pending',
          },
          {
            id: '2',
            userId: 'user2',
            gameId: 'game2',
            gameName: 'Delhi King',
            betTypeId: 'jodi',
            betTypeName: 'Jodi',
            amount: 50.00,
            betNumber: '56',
            placedAt: new Date('2023-09-15T11:15:00'),
            status: 'won',
            winAmount: 4750.00,
          },
          {
            id: '3',
            userId: 'user3',
            gameId: 'game1',
            gameName: 'Mumbai Main',
            betTypeId: 'patti',
            betTypeName: 'Patti',
            amount: 200.00,
            betNumber: '123',
            placedAt: new Date('2023-09-15T12:00:00'),
            status: 'lost',
          },
          {
            id: '4',
            userId: 'user1',
            gameId: 'game3',
            gameName: 'Rajasthan Royal',
            betTypeId: 'single',
            betTypeName: 'Single',
            amount: 75.00,
            betNumber: '8',
            placedAt: new Date('2023-09-15T13:45:00'),
            status: 'pending',
          },
        ];
        
        setBets(mockBets);
      } catch (error) {
        console.error('Error fetching bets:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchBets();
  }, []);

  const handleSearch = (e) => {
    setSearch(e.target.value);
  };

  const handleStatusChange = (e) => {
    setStatusFilter(e.target.value);
  };

  const handleApprove = (betId) => {
    setBets(bets.map(bet => 
      bet.id === betId ? {...bet, status: 'won'} : bet
    ));
  };

  const handleReject = (betId) => {
    setBets(bets.map(bet => 
      bet.id === betId ? {...bet, status: 'lost'} : bet
    ));
  };

  const handleCancel = (betId) => {
    setBets(bets.map(bet => 
      bet.id === betId ? {...bet, status: 'cancelled'} : bet
    ));
  };

  const getStatusChip = (status) => {
    switch (status) {
      case 'pending':
        return <Chip label="Pending" color="warning" size="small" />;
      case 'won':
        return <Chip label="Won" color="success" size="small" />;
      case 'lost':
        return <Chip label="Lost" color="error" size="small" />;
      case 'cancelled':
        return <Chip label="Cancelled" color="default" size="small" />;
      default:
        return <Chip label={status} size="small" />;
    }
  };

  const filteredBets = bets.filter(bet => {
    const matchesSearch = 
      bet.gameName.toLowerCase().includes(search.toLowerCase()) ||
      bet.betNumber.includes(search) ||
      bet.betTypeName.toLowerCase().includes(search.toLowerCase());
    
    const matchesStatus = statusFilter ? bet.status === statusFilter : true;
    
    return matchesSearch && matchesStatus;
  });

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Typography variant="h4" gutterBottom>
        Bet Management
      </Typography>

      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box display="flex" gap={2} alignItems="center" flexWrap="wrap">
            <TextField
              variant="outlined"
              placeholder="Search bets..."
              value={search}
              onChange={handleSearch}
              InputProps={{
                startAdornment: <SearchIcon sx={{ mr: 1, color: 'gray' }} />,
              }}
              sx={{ flex: 1, minWidth: 200 }}
            />
            <FormControl sx={{ minWidth: 150 }}>
              <InputLabel>Status</InputLabel>
              <Select
                value={statusFilter}
                label="Status"
                onChange={handleStatusChange}
              >
                <MenuItem value="">All</MenuItem>
                <MenuItem value="pending">Pending</MenuItem>
                <MenuItem value="won">Won</MenuItem>
                <MenuItem value="lost">Lost</MenuItem>
                <MenuItem value="cancelled">Cancelled</MenuItem>
              </Select>
            </FormControl>
          </Box>
        </CardContent>
      </Card>

      <Card>
        <CardContent>
          {loading ? (
            <Box display="flex" justifyContent="center" my={4}>
              <CircularProgress />
            </Box>
          ) : (
            <TableContainer component={Paper}>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>Game</TableCell>
                    <TableCell>Bet Type</TableCell>
                    <TableCell>Bet Number</TableCell>
                    <TableCell>Amount</TableCell>
                    <TableCell>User</TableCell>
                    <TableCell>Placed At</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredBets.map((bet) => (
                    <TableRow key={bet.id}>
                      <TableCell>{bet.gameName}</TableCell>
                      <TableCell>{bet.betTypeName}</TableCell>
                      <TableCell>{bet.betNumber}</TableCell>
                      <TableCell>₹{bet.amount.toFixed(2)}</TableCell>
                      <TableCell>{bet.userId}</TableCell>
                      <TableCell>
                        {bet.placedAt.toLocaleDateString()} {bet.placedAt.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
                      </TableCell>
                      <TableCell>{getStatusChip(bet.status)}</TableCell>
                      <TableCell>
                        {bet.status === 'pending' && (
                          <>
                            <IconButton 
                              color="success" 
                              onClick={() => handleApprove(bet.id)}
                              title="Approve"
                            >
                              <CheckIcon />
                            </IconButton>
                            <IconButton 
                              color="error" 
                              onClick={() => handleReject(bet.id)}
                              title="Reject"
                            >
                              <CloseIcon />
                            </IconButton>
                            <IconButton 
                              color="default" 
                              onClick={() => handleCancel(bet.id)}
                              title="Cancel"
                            >
                              <CancelIcon />
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

export default Bets;