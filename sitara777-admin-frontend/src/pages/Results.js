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
  Fab,
} from '@mui/material';
import {
  Search as SearchIcon,
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
} from '@mui/icons-material';

const Results = () => {
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedResult, setSelectedResult] = useState(null);
  const [formData, setFormData] = useState({
    gameId: '',
    gameName: '',
    date: '',
    session: 'open',
    result: '',
  });

  // Simulate fetching results
  useEffect(() => {
    const fetchResults = async () => {
      setLoading(true);
      try {
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Mock data
        const mockResults = [
          {
            resultId: '1',
            gameId: 'game1',
            gameName: 'Mumbai Main',
            date: '2023-09-15',
            session: 'open',
            result: '123',
            declaredAt: new Date('2023-09-15T10:30:00'),
            declaredBy: 'admin',
          },
          {
            resultId: '2',
            gameId: 'game1',
            gameName: 'Mumbai Main',
            date: '2023-09-15',
            session: 'close',
            result: '456',
            declaredAt: new Date('2023-09-15T20:30:00'),
            declaredBy: 'admin',
          },
          {
            resultId: '3',
            gameId: 'game2',
            gameName: 'Delhi King',
            date: '2023-09-15',
            session: 'open',
            result: '789',
            declaredAt: new Date('2023-09-15T11:30:00'),
            declaredBy: 'admin',
          },
        ];
        
        setResults(mockResults);
      } catch (error) {
        console.error('Error fetching results:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchResults();
  }, []);

  const handleSearch = (e) => {
    setSearch(e.target.value);
  };

  const handleAddResult = () => {
    setSelectedResult(null);
    setFormData({
      gameId: '',
      gameName: '',
      date: '',
      session: 'open',
      result: '',
    });
    setOpenDialog(true);
  };

  const handleEdit = (result) => {
    setSelectedResult(result);
    setFormData({
      gameId: result.gameId,
      gameName: result.gameName,
      date: result.date,
      session: result.session,
      result: result.result,
    });
    setOpenDialog(true);
  };

  const handleDelete = (resultId) => {
    if (window.confirm('Are you sure you want to delete this result?')) {
      setResults(results.filter(result => result.resultId !== resultId));
    }
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedResult(null);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle form submission
    handleCloseDialog();
  };

  const getSessionChip = (session) => {
    switch (session) {
      case 'open':
        return <Chip label="Open" color="primary" size="small" />;
      case 'close':
        return <Chip label="Close" color="secondary" size="small" />;
      default:
        return <Chip label={session} size="small" />;
    }
  };

  const filteredResults = results.filter(result => 
    result.gameName.toLowerCase().includes(search.toLowerCase()) ||
    result.result.includes(search) ||
    result.date.includes(search)
  );

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Game Results</Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={handleAddResult}
        >
          Add Result
        </Button>
      </Box>

      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box display="flex" alignItems="center">
            <TextField
              fullWidth
              variant="outlined"
              placeholder="Search results..."
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
                    <TableCell>Date</TableCell>
                    <TableCell>Session</TableCell>
                    <TableCell>Result</TableCell>
                    <TableCell>Declared At</TableCell>
                    <TableCell>Declared By</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredResults.map((result) => (
                    <TableRow key={result.resultId}>
                      <TableCell>{result.gameName}</TableCell>
                      <TableCell>{result.date}</TableCell>
                      <TableCell>{getSessionChip(result.session)}</TableCell>
                      <TableCell>
                        <Chip label={result.result} variant="outlined" />
                      </TableCell>
                      <TableCell>
                        {result.declaredAt.toLocaleDateString()} {result.declaredAt.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
                      </TableCell>
                      <TableCell>{result.declaredBy}</TableCell>
                      <TableCell>
                        <IconButton onClick={() => handleEdit(result)}>
                          <EditIcon />
                        </IconButton>
                        <IconButton onClick={() => handleDelete(result.resultId)}>
                          <DeleteIcon />
                        </IconButton>
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
          {selectedResult ? 'Edit Result' : 'Add Result'}
        </DialogTitle>
        <DialogContent>
          <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1 }}>
            <TextField
              autoFocus
              margin="dense"
              name="gameName"
              label="Game Name"
              type="text"
              fullWidth
              variant="outlined"
              value={formData.gameName}
              onChange={(e) => setFormData({...formData, gameName: e.target.value})}
              required
            />
            <TextField
              margin="dense"
              name="date"
              label="Date"
              type="date"
              fullWidth
              variant="outlined"
              value={formData.date}
              onChange={(e) => setFormData({...formData, date: e.target.value})}
              InputLabelProps={{
                shrink: true,
              }}
              required
            />
            <FormControl fullWidth margin="dense">
              <InputLabel>Session</InputLabel>
              <Select
                value={formData.session}
                label="Session"
                onChange={(e) => setFormData({...formData, session: e.target.value})}
              >
                <MenuItem value="open">Open</MenuItem>
                <MenuItem value="close">Close</MenuItem>
              </Select>
            </FormControl>
            <TextField
              margin="dense"
              name="result"
              label="Result"
              type="text"
              fullWidth
              variant="outlined"
              value={formData.result}
              onChange={(e) => setFormData({...formData, result: e.target.value})}
              required
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            {selectedResult ? 'Update' : 'Add'}
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default Results;