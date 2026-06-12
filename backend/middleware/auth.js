const jwt = require('jsonwebtoken');
const supabase = require('../supabase');

const auth = async (req, res, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (!token) return res.status(401).json({ error: 'No token provided' });
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const { data: user, error } = await supabase
      .from('users').select('*').eq('id', decoded.userId).single();
    if (error || !user) return res.status(401).json({ error: 'Invalid token' });
    req.user = user;
    next();
  } catch (err) {
    res.status(401).json({ error: 'Authentication failed' });
  }
};

const adminOnly = async (req, res, next) => {
  try {
    const { data: role, error } = await supabase.from('roles').select('permissions').eq('name', req.user.role).single();
    if (error) {
      console.error('adminOnly role fetch error:', error.message);
      // Fallback: check if role is admin or owner
      if (['admin', 'owner'].includes(req.user.role)) return next();
      return res.status(403).json({ error: 'Admin access required' });
    }
    if (!role?.permissions?.canAccessAdminPanel) return res.status(403).json({ error: 'Admin access required' });
    next();
  } catch (err) {
    console.error('adminOnly error:', err.message);
    // Fallback check
    if (['admin', 'owner'].includes(req.user.role)) return next();
    res.status(403).json({ error: 'Admin access required' });
  }
};

const ownerOnly = (req, res, next) => {
  if (req.user.role !== 'owner') return res.status(403).json({ error: 'Owner access required' });
  next();
};

module.exports = { auth, adminOnly, ownerOnly };
