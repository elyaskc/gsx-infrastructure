# Documentación Week 5


## Plan de Direccionamiento IP (CIDR)

Subred        		| CIDR          | IPs disponibles | Uso
------------------------|---------------|-----------------|----------------------------------
Organización completa   | 10.0.0.0/16	| 65534		  | Rango global
			|		| 		  |
DMZ           		| 10.0.0.0/24	| 254		  | Servicios expuestos al exterior
              		|		| 		  |
Desarrollo		| 10.0.1.0/24	| 254		  | Entorno de desarrollo
			|		| 		  |
Staging			| 10.0.2.0/24	| 254		  | Entorno de pruebas
			|		|		  |
Producción		| 10.0.3.0/24	| 254	 	  | Entorno productivo
			|		| 		  |
Base de Datos		| 10.0.4.0/24	| 254		  | Servidores de BBDD
			|		|		  |
Partners		| 10.0.10.0/24	| 254		  | Acceso externo controlado


Hemos elegido subredes /24 ya que la organización GreenDevCorp tiene 20 personas y no se necesitan tantas IPs por subred. El rango /16 para toda la organización da margen para crecer y añadir nuevas subredes sin tener que rediseñar la arquitectura.
La separación en subredes distintas sigue el principio de defensa en profundidad, es decir, si un atacante compromete un servicio en la DMZ, no tiene acceso directo a la base de datos ni a entornos internos.


## Servicios de Red Fundamentales

- DNS (Domain Name System): DNS es el sistema que traduce nombres de dominio legibles para las personas en direcciones IP que entienden las máquinas. 
  Sin el DNS, las personas tendríamos que memorizar las IPs de cada servicio que se quiera acceder.
  Para una organización como GreenDevCorp, DNS interno permite que los servicios se comuniquen entre sí por nombre en vez de por IP. Esto es crítico porque las IPs pueden cambiar cuando se reinician contenedores o servidores, mientras que el nombre es persistente.

- DHCP (Dynamic Host Configuration Protocol): DHCP es el protocolo que asigna automáticamente configuración de red (IP, máscara de red, subred, puerta de enlace, DNS) a los dispositivos cuando se conectan a una red.
  Sin DHCP, un admin tendría que configurar manualmente la IP de cada ordenador, servidor o dispositivo.
  En una organización como GreenDevCorp con 20 personas y múltiples dispositivos por empleado, DHCP es imprescindible. Permite que un nuevo empleado conecte su portátil a la red y obtenga configuración automáticamente sin intervención del equipo de IT.
  También facilita gestionar qué IPs están en uso y evita conflictos de direcciones duplicadas. 


- NTP (Network Time Protocol): NTP sincroniza los relojes de todos los sistemas de una red con una fuente de tiempo de referencia. En seguridad, muchos protocolos de autenticación fallan si los relojes de los sistemas difieren de más de 5 min. Los certificados SSL/TLS tienen fechas de validez que se verifican contra el reloj del sistema.
  En operaciones, los logs de todos los servidores deben tener timestamps sincronizados para poder correlacionar eventos y diagnosticar problemas.



## Gestión de Identidad

- Autenticación vs Autorización
  
  - Autenticación: es el proceso de verificar que alguien es quien dice ser. Los mecanismos más comunes son contraseñas, certificados digitales o MFA. Cuando introduces tu user y contraseña al iniciar sesión, te estás autenticando.
  - Autorización: es el proceso de determinar qué puede hacer una identidad ya autenticada. Por ejemplo, un desarrollador autenticado puede acceder al entorno de desarrollo pero no al de producción. Un admin autenticado puede acceder a todo. La autorización siempre viene después de la autenticación.


- LDAP (Lightweight Directory Access Protocol): es un protocolo estándar para acceder y mantener directorios de información distribuida, típicamente users y grupos de una organización. Funciona como una base de datos especializada en relaciones jerárquicas.
  Con LDAP centralizado, todos los sistemas de la organización (VPN, Email, aplicaciones internas, servers) consultan el mismo directorio para autenticar users.
  Si un empleado abandona la organización, basta con desactivar su cuenta en LDAP y automáticamente pierde acceso a todos los sistemas.


- AD (Active Directory): es la implementación de LDAP de Microsoft, ampliamente adoptada en entornos de empresa. Añade sobre LDAP funcionalidades como políticas de grupo (Group Policy), que permiten configurar automáticamente los ordenadores de la organización y Kerberos para autenticación segura en red.
  Es el estándar de facto en empresas que usan entornos Windows, aunque también puede autenticar sistemas Linux y aplicaciones web.


- SSO (Single Sign-On): SSO permite que un user se autentique una sola vez y acceda a múltiples aplicaciones sin tener que introducir de nuevo las credenciales.
  Como ejemplo, en Google Workspace, si inicias sesión en Gmail, automáticamente estás autenticado en Google Drive, Google Calendar y el resto de aplicaciones.
  Para una empresa, SSO mejora tanto la seguridad (los users tienen menos contraseñas que gestionar, lo que reduce el uso de contraseñas débiles o reutilizadas) como la productividad (no hay que iniciar sesión en cada herramienta o servicio por separado)



## Estrategia de Identidad para GreenDevCorp

Para una organización de 20 personas en crecimiento, se recomienda adoptar una solución de IdP (Identity Provider) en la nube como Google Workspace o Microsoft Entra ID (Azure AD), combinada con SSO para todas las aplicaciones internas.
Una solución en la nube es preferible a montar un servidor LDAP/AD propio. El mantenimiento de un servidor de directorio propio requiere un administrador dedicado, backups, alta disponibilidad y actualizaciones de seguridad constantes. Las soluciones en la nube eliminan esta carga operativa.

Implementación propuesta:

1. Google Workspace o Microsoft Entra ID como directorio central de users
2. SSO mediante SAML u OAth para todas las aplicaciones internas
3. MFA obligatorio para todos los empleados, especialmente para el acceso a producción
4. Grupos por rol: developers, devops, data-analysts, management. Cada uno con permisos distintos.
5. Principio de mínimo privilegio: cada empleado solo tiene acceso a lo que necesita para su trabajo.

Trade-offs

		|   IdP en la nube	|   LDAP/AD propio
----------------|-----------------------|---------------------------
Coste		|  Suscripción mensual	|  Infraestructura propia
		|			|
		|			|
Mantenimiento	|  Mínimo		|  Alto
		|			|
		|			|
Control 	|   Limitado	        |  Total
		|			|
		|			|
Escalabilidad	|  Automática		|  Manual



IdP en la nube es adecuado para GreenDevCorp y LDAP/AD es excesivo para 20 personas

