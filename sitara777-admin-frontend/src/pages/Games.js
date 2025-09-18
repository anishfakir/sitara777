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
  Switch,
  FormControlLabel,
} from '@mui/material';
import {
  Search as SearchIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
} from '@mui/icons-material';

const Games = () => {
  const [games, setGames] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedGame, setSelectedGame] = useState(null);
  const [formData, setFormData] = useState({
    name: '',
    displayName: '',
    description: '',
    category: '',
    isActive: true,
    openTime: '10:00',
    closeTime: '20:00',
    resultTime: '20:30',
  });

  // Simulate fetching games
  useEffect(() => {
    const fetchGames = async () => {
      setLoading(true);
      try {
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Mock data
        const mockGames = [
          {
            gameId: '1',
            name: 'mumbai_main',
            displayName: 'Mumbai Main',
            description: 'Main Mumbai matka game',
            category: 'main',
            isActive: true,
            openTime: '10:00',
            closeTime: '20:00',
            resultTime: '20:30',
            type: 'matka',
          },
          {
            gameId: '2',
            name: 'delhi_king',
            displayName: 'Delhi King',
            description: 'Delhi matka game',
            category: 'main',
            isActive: false,
            openTime: '11:00',
            closeTime: '19:00',
            resultTime: '19:30',
            type: 'matka',
          },
          {
            gameId: '3',
            name: 'rajasthan_royal',
            displayName: 'Rajasthan Royal',
            description: 'Rajasthan matka game',
            category: 'main',
            isActive: true,
            openTime: '09:00',
            closeTime: '21:00',
            resultTime: '21:30',
            type: 'matka',
          },
        ];
        
        setGames(mockGames);
      } catch (error) {
        console.error('Error fetching games:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchGames();
  }, []);

  const handleSearch = (e) => {
    setSearch(e.target.value);
  };

  const handleEdit = (game) => {
    setSelectedGame(game);
    setFormData({
      name: game.name,
      displayName: game.displayName,
      description: game.description,
      category: game.category,
      isActive: game.isActive,
      openTime: game.openTime,
      closeTime: game.closeTime,
      resultTime: game.resultTime,
    });
    setOpenDialog(true);
  };

  const handleDelete = (gameId) => {
    if (window.confirm('Are you sure you want to delete this game?')) {
      setGames(games.filter(game => game.gameId !== gameId));
    }
  };

  const handleAddGame = () => {
    setSelectedGame(null);
    setFormData({
      name: '',
      displayName: '',
      description: '',
      category: '',
      isActive: true,
      openTime: '10:00',
      closeTime: '20:00',
      resultTime: '20:30',
    });
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedGame(null);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle form submission
    handleCloseDialog();
  };

  const filteredGames = games.filter(game =>
    game.name.toLowerCase().includes(search.toLowerCase()) ||
    game.displayName.toLowerCase().includes(search.toLowerCase()) ||
    game.category.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Game Management</Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={handleAddGame}
        >
          Add Game
        </Button>
      </Box>

      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box display="flex" alignItems="center">
            <TextField
              fullWidth
              variant="outlined"
              placeholder="Search games..."
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
                    <TableCell>Name</TableCell>
                    <TableCell>Display Name</TableCell>
                    <TableCell>Category</TableCell>
                    <TableCell>Open Time</TableCell>
                    <TableCell>Close Time</TableCell>
                    <TableCell>Result Time</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredGames.map((game) => (
                    <TableRow key={game.gameId}>
                      <TableCell>{game.name}</TableCell>
                      <TableCell>{game.displayName}</TableCell>
                      <TableCell>{game.category}</TableCell>
                      <TableCell>{game.openTime}</TableCell>
                      <TableCell>{game.closeTime}</TableCell>
                      <TableCell>{game.resultTime}</TableCell>
                      <TableCell>
                        <Switch
                          checked={game.isActive}
                          color="primary"
                        />
                      </TableCell>
                      <TableCell>
                        <IconButton onClick={() => handleEdit(game)}>
                          <EditIcon />
                        </IconButton>
                        <IconButton onClick={() => handleDelete(game.gameId)}>
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
          {selectedGame ? 'Edit Game' : 'Add Game'}
        </DialogTitle>
        <DialogContent>
          <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1 }}>
            <TextField
              autoFocus
              margin="dense"
              name="name"
              label="Name"
              type="text"
              fullWidth
              variant="outlined"
              value={formData.name}
              onChange={(e) => setFormData({...formData, name: e.target.value})}
              required
            />
            <TextField
              margin="dense"
              name="displayName"
              label="Display Name"
              type="text"
              fullWidth
              variant="outlined"
              value={formData.displayName}
              onChange={(e) => setFormData({...formData, displayName: e.target.value})}
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
            />
            <TextField
              margin="dense"
              name="category"
              label="Category"
              type="text"
              fullWidth
              variant="outlined"
              value={formData.category}
              onChange={(e) => setFormData({...formData, category: e.target.value})}
            />
            <Box display="flex" gap={2}>
              <TextField
                margin="dense"
                name="openTime"
                label="Open Time"
                type="time"
                fullWidth
                variant="outlined"
                value={formData.openTime}
                onChange={(e) => setFormData({...formData, openTime: e.target.value})}
                InputLabelProps={{
                  shrink: true,
                }}
              />
              <TextField
                margin="dense"
                name="closeTime"
                label="Close Time"
                type="time"
                fullWidth
                variant="outlined"
                value={formData.closeTime}
                onChange={(e) => setFormData({...formData, closeTime: e.target.value})}
                InputLabelProps={{
                  shrink: true,
                }}
              />
            </Box>
            <TextField
              margin="dense"
              name="resultTime"
              label="Result Time"
              type="time"
              fullWidth
              variant="outlined"
              value={formData.resultTime}
              onChange={(e) => setFormData({...formData, resultTime: e.target.value})}
              InputLabelProps={{
                shrink: true,
              }}
            />
            <FormControlLabel
              control={
                <Switch
                  checked={formData.isActive}
                  onChange={(e) => setFormData({...formData, isActive: e.target.checked})}
                  color="primary"
                />
              }
              label="Active"
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            {selectedGame ? 'Update' : 'Add'}
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default Games;