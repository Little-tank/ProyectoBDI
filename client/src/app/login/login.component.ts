import { Component, OnInit, HostBinding } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';

import { IngresoService } from '../services/ingreso.service';
import {CommonService} from '../services/common.service';
import { Usuario } from '../models/usuario';



@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  @HostBinding('class') classes = 'row';

  loading:boolean = false;  
  usuarioI:String = '';
  passwordI:String = '';
 

  usuario: Usuario = {
    id: 0,
    nombre: '',
    contrasena: ''
  };

  respuesta: any = [{
    nombre: '',
    contrasena: ''
  }];

  error:boolean = false;


  constructor(private usuarioService: IngresoService, private router: Router, private activatedRoute: ActivatedRoute, private common: CommonService) { }

  ngOnInit(): void {
  }

  getsUsuario(){
    delete this.usuario.id;
    this.error = false;
    this.usuarioService.getoneUsuario(this.usuario.nombre, this.usuario.contrasena).subscribe(
      res => {
        this.respuesta = res;
        console.log(this.respuesta)
        if (this.respuesta.nombre  == 'Usuario y/o contraseña incorrecto'){
          this.error = true;
          this.loading = false;       
          this.usuario.nombre = '';
          this.usuario.contrasena = '';
          window.alert("Error en Nombre de Usuario y/o contraseña");
        }
        else {
          this.loading = false;          
          this.common.loggedIn = true;
          console.log(res);
          this.router.navigate(['/']);
        }
        
      },
      err => console.log(err)
    )
  }

}
