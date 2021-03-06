CREATE TABLE Direccion(
	clave		SERIAL,
	nombre	VARCHAR(80)	NOT NULL,
	CONSTRAINT PK_direccion PRIMARY KEY (clave)
);

CREATE TABLE Esencia_Perfume(
	tsca_cas		SERIAL,
	nombre	VARCHAR	NOT NULL,
    codint varchar,
	tipo_extraccion	VARCHAR(25) NOT NULL CHECK (tipo_extraccion = 'Maceracion' OR tipo_extraccion = 'Expresion' OR tipo_extraccion = 'Destilacion' OR tipo_extraccion = 'Enfleurage'),
    descripcion varchar not NULL,
    CONSTRAINT PK_Esencia_Perfume PRIMARY KEY (tsca_cas)
);

CREATE TABLE Intensidad(
	clave		SERIAL,
	tipo	VARCHAR NOT NULL CHECK (tipo = 'Perfume' OR tipo = 'Eau de Perfume' OR tipo = 'Eau de Toilette' OR tipo = 'Eau de Cologne' OR tipo = 'Splash perfumes'),
    concentracion NUMERIC not null,
    descripcion varchar,
    CONSTRAINT PK_Intensidad PRIMARY KEY (clave)
);

CREATE TABLE Familia_Olfativa(
	clave		SERIAL,
	nombre	VARCHAR NOT NULL,
    descripcion	VARCHAR NOT NULL,
    CONSTRAINT PK_Familia_Olfativa PRIMARY KEY (clave)
);

CREATE TABLE Presentacion(
	clave		SERIAL,
	volml	INTEGER	NOT NULL,
    CONSTRAINT PK_Presentacion PRIMARY KEY (clave)
);

CREATE TABLE Palabra_Clave(
	clave		SERIAL,
	palabra	VARCHAR NOT NULL,
    CONSTRAINT PK_Fase PRIMARY KEY (clave)
);

CREATE TABLE P_F(
	clave		SERIAL,
    fk_palabra_clave	INTEGER NOT NULL,
    fk_familia_olfativa INTEGER NOT NULL,
    CONSTRAINT PK_P_F PRIMARY KEY (clave),
	CONSTRAINT FK_fk_palabra_clave FOREIGN KEY (fk_palabra_clave)
	REFERENCES Palabra_Clave (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_familia_olfativa FOREIGN KEY (fk_familia_olfativa)
	REFERENCES Familia_Olfativa (clave) ON DELETE CASCADE

);


CREATE TABLE Perfumista(
	clave		SERIAL,
	nombre	VARCHAR NOT NULL,
    apellido varchar not null,
    genero varchar not null check (genero = 'Masculino' OR genero = 'Femenino'),
    fk_direccion INTEGER NOT NULL,
    CONSTRAINT PK_Perfumista PRIMARY KEY (clave),
    CONSTRAINT FK_fk_direccion FOREIGN KEY (fk_direccion)
	REFERENCES Direccion (clave) ON DELETE CASCADE
);

CREATE TABLE Asociacion_Nacional(
	clave		SERIAL,
	nombre	VARCHAR(80)	NOT NULL,
    region varchar NOT NULL check (region = 'AsiaPacífico' OR region = 'Europa' OR region = 'América Latina' OR region = 'NorteAmérica'),
	CONSTRAINT PK_Asociacion_Nacional PRIMARY KEY (clave)
);

CREATE TABLE Productor(
	clave		SERIAL,
    nombre VARCHAR NOT NULL,
    pag_web VARCHAR NOT NULL,
    telefono varchar NOT NULL,
    fk_asociacion_nacional INTEGER,
    CONSTRAINT PK_Productor PRIMARY KEY (clave),
    CONSTRAINT FK_fk_asociacion_nacional FOREIGN KEY (fk_asociacion_nacional)
	REFERENCES Asociacion_Nacional (clave) ON DELETE CASCADE,
    CONSTRAINT Productor_Unique UNIQUE (nombre)
);

CREATE TABLE Perfume(
	clave		SERIAL,
	nombre	VARCHAR(80)	NOT NULL,
    fecha_nacimiento date NOT NULL,
    genero           VARCHAR(25) NOT NULL CHECK (genero = 'Masculino' OR genero = 'Femenino' OR genero = 'Unisex'),
	fk_productor	INTEGER NOT NULL,
	CONSTRAINT PK_Perfume PRIMARY KEY (clave),
	CONSTRAINT FK_fk_productor FOREIGN KEY (fk_productor)
	REFERENCES Productor (clave) ON DELETE CASCADE
);


CREATE TABLE F_E(
	clave		SERIAL,
	fk_esencia_perfume		INTEGER NOT NULL,
	fk_familia_olfativa	INTEGER NOT NULL,
	CONSTRAINT PK_F_E PRIMARY KEY (clave),
	CONSTRAINT FK_fk_esencia_perfume FOREIGN KEY (fk_esencia_perfume)
	REFERENCES Esencia_Perfume (tsca_cas) ON DELETE CASCADE,
    CONSTRAINT FK_fk_familia_olfativa FOREIGN KEY (fk_familia_olfativa)
	REFERENCES Familia_Olfativa (clave) ON DELETE CASCADE
);


CREATE TABLE Monolitico(
	clave		SERIAL,
    fk_perfume INTEGER NOT NULL,
    fk_esencia_perfume INTEGER NOT NULL,
    CONSTRAINT PK_Monolitico PRIMARY KEY (clave),
    CONSTRAINT FK_fk_perfume FOREIGN KEY (fk_perfume)
	REFERENCES Perfume (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_esencia_perfume FOREIGN KEY (fk_esencia_perfume)
	REFERENCES Esencia_Perfume (tsca_cas) ON DELETE CASCADE
);

CREATE TABLE Proveedor(
	clave		SERIAL,
    nombre VARCHAR NOT NULL,
    pag_web VARCHAR NOT NULL,
    telefono varchar NOT NULL,
    fk_asociacion_nacional INTEGER,
    fk_direccion INTEGER NOT NULL,
    CONSTRAINT PK_Proveedor PRIMARY KEY (clave),
    CONSTRAINT FK_fk_asociacion_nacional FOREIGN KEY (fk_asociacion_nacional)
	REFERENCES Asociacion_Nacional (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_direccion FOREIGN KEY (fk_direccion)
	REFERENCES Direccion (clave) ON DELETE CASCADE,
    CONSTRAINT Proveedor_Unique UNIQUE (nombre)
);

CREATE TABLE Ing_Materia_Esencial(
	ipc		SERIAL,
    tsca_cas NUMERIC,
    nombre varchar not null,
    descripcion varchar null null,
    solubilidad varchar,
    proceso varchar not null,
    descripproceso varchar,
    vigencia varchar,
    fk_proveedor INTEGER NOT NULL,
    CONSTRAINT PK_Ing_Materia_Esencial PRIMARY KEY (ipc),
    CONSTRAINT FK_fk_proveedor FOREIGN KEY (fk_proveedor)
	REFERENCES Proveedor (clave) ON DELETE CASCADE
);

CREATE TABLE Per_Fas(
	clave		SERIAL,
    tipo_nota varchar not null CHECK (tipo_nota = 'notas de salida' OR tipo_nota = 'notas de corazón' OR tipo_nota = 'notas de fondo'),
    fk_perfume INTEGER NOT NULL,
    fk_esencia_perfume INTEGER NOT NULL,
    CONSTRAINT PK_Per_Fas PRIMARY KEY (clave),
    CONSTRAINT FK_fk_perfume FOREIGN KEY (fk_perfume)
	REFERENCES Perfume (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_esencia_perfume FOREIGN KEY (fk_esencia_perfume)
	REFERENCES Esencia_Perfume (tsca_cas) ON DELETE CASCADE
);

CREATE TABLE Ingrediente_Otro(
	clave		SERIAL,
	nombre	VARCHAR NOT NULL,
    ipc NUMERIC,
    tsca_cas NUMERIC,
    fk_proveedor INTEGER NOT NULL,
    CONSTRAINT PK_Ingrediente_Otro PRIMARY KEY (clave),
    CONSTRAINT FK_fk_proveedor FOREIGN KEY (fk_proveedor)
	REFERENCES Proveedor (clave) ON DELETE CASCADE
);

CREATE TABLE Otro(
	clave		SERIAL,
    fk_perfume INTEGER NOT NULL,
    fk_ingrediente_otro INTEGER NOT NULL,
    CONSTRAINT PK_Otro PRIMARY KEY (clave),
    CONSTRAINT FK_fk_perfume FOREIGN KEY (fk_perfume)
	REFERENCES Perfume (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_ingrediente FOREIGN KEY (fk_ingrediente_otro)
	REFERENCES Ingrediente_Otro (clave) ON DELETE CASCADE
);

CREATE TABLE F_Ima(
	clave		SERIAL,
    fk_ing_materia_esencial INTEGER NOT NULL,
    fk_familia_olfativa INTEGER NOT NULL,
    CONSTRAINT PK_F_Ima PRIMARY KEY (clave),
    CONSTRAINT FK_fk_ing_materia_esencial FOREIGN KEY (fk_ing_materia_esencial)
	REFERENCES Ing_Materia_Esencial (ipc) ON DELETE CASCADE,
    CONSTRAINT FK_fk_familia_olfativa FOREIGN KEY (fk_familia_olfativa)
	REFERENCES Familia_Olfativa (clave) ON DELETE CASCADE
);

CREATE TABLE Contrato(
	clave		SERIAL,
	fecha_inicio date NOT NULL,
    fecha_cancela date,
    descripcion varchar,
    motivo_cancela varchar,
    exclusividad boolean not null,
    fk_proveedor INTEGER NOT NULL,
    fk_productor INTEGER NOT NULL,
    CONSTRAINT PK_Contrato PRIMARY KEY (clave),
    CONSTRAINT FK_fk_proveedor FOREIGN KEY (fk_proveedor)
	REFERENCES Proveedor (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_productor FOREIGN KEY (fk_productor)
	REFERENCES Productor (clave) ON DELETE CASCADE
);

CREATE TABLE Productor_Pais(
	clave		SERIAL,
    fk_direccion INTEGER NOT NULL,
    fk_productor INTEGER NOT NULL,
    CONSTRAINT PK_Productor_Pais PRIMARY KEY (clave),
    CONSTRAINT FK_fk_direccion FOREIGN KEY (fk_direccion)
	REFERENCES Direccion (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_productor FOREIGN KEY (fk_productor)
	REFERENCES Productor (clave) ON DELETE CASCADE
);

CREATE TABLE Principal(
    clave          SERIAL,
    fk_perfume  INTEGER NOT NULL,
    fk_familia_olfativa  INTEGER NOT NULL,
    CONSTRAINT PK_Principal PRIMARY KEY (clave),
    CONSTRAINT FK_fk_perfume FOREIGN KEY (fk_perfume)
    REFERENCES Perfume (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_familia_olfativa FOREIGN KEY (fk_familia_olfativa)
    REFERENCES Familia_Olfativa (clave) ON DELETE CASCADE
);

CREATE TABLE Otro_Comp(
    clave          SERIAL,
    fk_ingrediente_otro   INTEGER NOT NULL,
    fk_ing_materia_esencial   INTEGER NOT NULL,
    CONSTRAINT PK_Otro_Comp PRIMARY KEY (clave),
    CONSTRAINT FK_fk_ingrediente_otro FOREIGN KEY (fk_ingrediente_otro)
    REFERENCES Ingrediente_Otro (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_ing_materia_esencial FOREIGN KEY (fk_ing_materia_esencial)
    REFERENCES Ing_Materia_Esencial (ipc) ON DELETE CASCADE
);

CREATE TABLE Catalogo(
	clave		SERIAL,
    fk_contrato INTEGER NOT NULL,
    fk_perfume INTEGER NOT NULL,
    fk_ingrediente_otro	INTEGER,
    fk_ing_materia_esencial	INTEGER,
    CONSTRAINT PK_Catalogo PRIMARY KEY (clave),
    CONSTRAINT FK_fk_contrato FOREIGN KEY (fk_contrato)
	REFERENCES Contrato (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_perfume FOREIGN KEY (fk_perfume)
	REFERENCES Perfume (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_ingrediente_otro FOREIGN KEY (fk_ingrediente_otro)
	REFERENCES Ingrediente_Otro (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_ing_materia_esencial FOREIGN KEY (fk_ing_materia_esencial)
	REFERENCES Ing_Materia_Esencial (ipc) ON DELETE CASCADE
);

CREATE TABLE Origen(
	clave		SERIAL,
    fk_direccion INTEGER NOT NULL,
    fk_ing_materia_esencial INTEGER NOT NULL,
    CONSTRAINT PK_Origen PRIMARY KEY (clave),
    CONSTRAINT FK_fk_direccion FOREIGN KEY (fk_direccion)
	REFERENCES Direccion (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_ing_materia_esencial FOREIGN KEY (fk_ing_materia_esencial)
	REFERENCES Ing_Materia_Esencial (ipc) ON DELETE CASCADE
);

CREATE TABLE Envio(
	clave		SERIAL,
    costo NUMERIC NOT NULL,
    recargo NUMERIC NOT NULL,
    tipo_transporte varchar not null CHECK (tipo_transporte = 'vehiculo' OR tipo_transporte = 'barco' OR tipo_transporte = 'avion'),
    fk_direccion INTEGER NOT NULL,
    fk_proveedor INTEGER NOT NULL,
    CONSTRAINT PK_Envio PRIMARY KEY (clave),
    CONSTRAINT FK_fk_direccion FOREIGN KEY (fk_direccion)
	REFERENCES Direccion (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_proveedor FOREIGN KEY (fk_proveedor)
	REFERENCES Proveedor (clave) ON DELETE CASCADE
);

CREATE TABLE Condicion_Pago(
    numero               SERIAL,
    tipo                 VARCHAR(20) NOT NULL CHECK (tipo = 'Transferencia' OR tipo = 'Tar_credito' OR tipo = 'Cheque' OR tipo = 'Tar_debito'),
    cuota                NUMERIC,
    porccuotas              NUMERIC,
    meses                NUMERIC,
    CONSTRAINT PK_Condicion_Pago PRIMARY KEY (numero)
);

CREATE TABLE Renueva(
    clave          SERIAL,
    fecha       DATE NOT NULL,
    fk_contrato    INTEGER NOT NULL,
    CONSTRAINT PK_Renueva PRIMARY KEY (clave),
    CONSTRAINT FK_fk_contrato FOREIGN KEY (fk_contrato)
    REFERENCES Contrato (clave) ON DELETE CASCADE
);

CREATE TABLE Cond_c(
    clave          SERIAL,
    fk_envio   INTEGER NOT NULL,
    fk_condicion_pago   INTEGER NOT NULL,
    fk_contrato   INTEGER NOT NULL,
    CONSTRAINT PK_Cond_c PRIMARY KEY (clave),
    CONSTRAINT FK_fk_envio FOREIGN KEY (fk_envio)
    REFERENCES Envio (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_condicion_pago FOREIGN KEY (fk_condicion_pago)
    REFERENCES Condicion_Pago (numero) ON DELETE CASCADE,
    CONSTRAINT FK_fk_contrato FOREIGN KEY (fk_contrato)
    REFERENCES Contrato (clave) ON DELETE CASCADE
);

CREATE TABLE Pedido(
	clave		SERIAL,
	fecha DATE NOT NULL,
    fecha_cont DATE,
    estatus varchar NOT NULL CHECK (estatus = 'Pendiente' OR estatus = 'Aceptado'),
    nro_factura NUMERIC,
    total NUMERIC not null,
    fk_cond_c INTEGER,
    fk_condicion_pago INTEGER,
    fk_proveedor INTEGER not null,
    CONSTRAINT PK_Pedido PRIMARY KEY (clave),
    CONSTRAINT FK_fk_cond_c FOREIGN KEY (fk_cond_c)
	REFERENCES Cond_c (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_condicion_pago FOREIGN KEY (fk_condicion_pago)
	REFERENCES Condicion_Pago (numero) ON DELETE CASCADE,
    CONSTRAINT FK_fk_proveedor FOREIGN KEY (fk_proveedor)
	REFERENCES Proveedor (clave) ON DELETE CASCADE
);

CREATE TABLE Pago(
    clave          SERIAL,
    monto       NUMERIC(10,2) NOT NULL,
    fecha       DATE NOT NULL,
    fk_pedido    INTEGER NOT NULL,
    CONSTRAINT PK_Pago PRIMARY KEY (clave),
    CONSTRAINT FK_fk_pedido FOREIGN KEY (fk_pedido)
    REFERENCES Pedido (clave) ON DELETE CASCADE
);

CREATE TABLE Presing(
    clave          SERIAL,
    volml         NUMERIC NOT NULL,
    precio_unitario         NUMERIC NOT NULL,
    fk_ingrediente_otro  INTEGER,
    fk_ing_materia_esencial INTEGER,
    CONSTRAINT PK_Presing PRIMARY KEY (clave),
    CONSTRAINT FK_fk_ingrediente_otro FOREIGN KEY (fk_ingrediente_otro)
    REFERENCES Ingrediente_Otro (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_ing_materia_esencial FOREIGN KEY (fk_ing_materia_esencial)
    REFERENCES Ing_Materia_Esencial (ipc) ON DELETE CASCADE
);

CREATE TABLE Def_Ped(
    clave          SERIAL,
    cantidad         VARCHAR NOT NULL,
    fk_pedido   INTEGER NOT NULL,
    CONSTRAINT PK_Def_Ped PRIMARY KEY (clave),
    CONSTRAINT FK_fk_pedido FOREIGN KEY (fk_pedido)
    REFERENCES Pedido (clave) ON DELETE CASCADE
);

CREATE TABLE Miembro_Ifra(
    clave          SERIAL,
    fechai         DATE NOT NULL,
    fechaf         DATE,
    tipo           VARCHAR not null CHECK (tipo = 'Principal' OR tipo = 'Secundario' OR tipo = 'Asociacion Nacional'), 
    fk_proveedor INTEGER,
    fk_productor INTEGER,
    CONSTRAINT PK_Miembro_Ifra PRIMARY KEY (clave),
    CONSTRAINT FK_fk_proveedor FOREIGN KEY (fk_proveedor)
	REFERENCES Proveedor (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_productor FOREIGN KEY (fk_productor)
	REFERENCES Productor (clave) ON DELETE CASCADE
);

CREATE TABLE Prohibida(
    tsca_cas          SERIAL,
    nombre         varchar NOT NULL,
    fk_miembro_ifra INTEGER not null,
    fk_ingrediente_otro INTEGER not null,
    CONSTRAINT PK_Prohibida PRIMARY KEY (tsca_cas),
    CONSTRAINT FK_fk_miembro_ifra FOREIGN KEY (fk_miembro_ifra)
	REFERENCES Miembro_Ifra (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_ingrediente_otro FOREIGN KEY (fk_ingrediente_otro)
	REFERENCES Ingrediente_Otro (clave) ON DELETE CASCADE
);

CREATE TABLE Resultado_Final(
    fecha          date not null,
    resultado         NUMERIC NOT NULL,
    tipoEval         VARCHAR not NULL CHECK (tipoEval = 'Inicial' OR tipoEval = 'Renovacion'),
    fk_proveedor INTEGER,
    fk_productor INTEGER,
    CONSTRAINT PK_Resultado_Final PRIMARY KEY (fecha),
    CONSTRAINT FK_fk_proveedor FOREIGN KEY (fk_proveedor)
	REFERENCES Proveedor (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_productor FOREIGN KEY (fk_productor)
	REFERENCES Productor (clave) ON DELETE CASCADE
);

CREATE TABLE Escala(
    fechai          date not null,
    fechaf          date,
    rangoi         NUMERIC NOT NULL,
    rangof         NUMERIC not NULL,
    fk_productor INTEGER,
    CONSTRAINT PK_Escala PRIMARY KEY (fechai),
    CONSTRAINT FK_fk_productor FOREIGN KEY (fk_productor)
	REFERENCES Productor (clave) ON DELETE CASCADE
);

CREATE TABLE Criterio(
    clave          serial,
    nombreEtiq          varchar not null,
    descripcion         varchar NOT NULL,
    CONSTRAINT PK_Criterio PRIMARY KEY (clave)
);

CREATE TABLE Cri_Eval(
    clave        serial,
    fechai          date not null,
    fechaf          date,
    peso         NUMERIC NOT NULL,
    tipoform         VARCHAR not NULL CHECK (tipoform = 'Inicial' OR tipoform = 'Final'),
    fk_productor INTEGER not null,
    fk_criterio INTEGER not null,
    CONSTRAINT PK_Cri_Eval PRIMARY KEY (clave),
    CONSTRAINT FK_fk_productor FOREIGN KEY (fk_productor)
	REFERENCES Productor (clave) ON DELETE CASCADE,
    CONSTRAINT FK_fk_criterio FOREIGN KEY (fk_criterio)
	REFERENCES Criterio (clave) ON DELETE CASCADE 
);
