extern crate openssl;
#[macro_use] extern crate maplit;
#[macro_use] extern crate serde_json;
#[macro_use] #[allow(unused_imports)] extern crate log;

use std::env;
use std::fmt::Write;

use dotenv::dotenv;
use actix_web::HttpServer;

mod core;
mod views;
mod settings;
mod app_factory;

use crate::settings::AppConfig;
use crate::core::errors::AppError;
use crate::app_factory::AppFactory;




#[actix_web::main]
async fn main() -> Result<(), AppError> {
    dotenv().ok();

    let serv_addr = env::var( "SERVICE_ADDR" ).unwrap_or( String::from( "0.0.0.0:8888" ) );
    let app_config = AppConfig::new() ?;

    let srv = HttpServer::new(move || {
        AppFactory::create_app()
            .data( app_config.clone() )
    });

    srv.bind( serv_addr ) ?
        .run()
        .await ?;

    Ok(())
}
