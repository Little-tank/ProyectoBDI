const loginCtrl = {};
const pool  = require('../database/database');

 loginCtrl.getoneUsuario = async (req, res) => {
    const id = req.params.id;
    const nombre = req.params.nombre;
    const contrasena = req.params.contrasena;
    await pool.query("select id, nombre, contrasena from usuario where nombre = '"+nombre+"' and contrasena = '"+contrasena+"';")
        .then(response => {
            if(response.rowCount)
                res.json(response.rows);                
            else
                res.json({ nombre: 'Usuario y/o contraseña incorrecto' }); 
        })
        .catch(err => {
            console.log(err);
            res.json('Ha ocurrido un error');
        })
};



module.exports = loginCtrl;

