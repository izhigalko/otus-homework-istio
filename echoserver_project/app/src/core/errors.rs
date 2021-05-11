use std::env::VarError;
use std::io::{ Error as IOError };
use std::fmt::{ Formatter, Display, Result as FmtResult };

use config::ConfigError;
use actix_web::http::StatusCode;
use serde::{ Serialize, Deserialize };
use actix_web::client::SendRequestError;
use log4rs::config::InitError as LogError;
use serde_json::Error as JsonSerializeError;
use actix_web::{ ResponseError, HttpResponse };




#[derive(Debug, Serialize, Deserialize)]
pub enum AppError {
    EnvError( String ),
    IOError( String ),
    LogError( String ),
    SerializeError( String ),
    InternalRequestError( String )
}

impl From<VarError> for AppError {
    fn from( err: VarError ) -> AppError {
        AppError::EnvError( err.to_string() )
    }
}
impl From<JsonSerializeError> for AppError {
    fn from( err: JsonSerializeError ) -> AppError {
        AppError::SerializeError( err.to_string() )
    }
}
impl From<SendRequestError> for AppError {
    fn from( err: SendRequestError ) -> AppError {
        AppError::InternalRequestError( err.to_string() )
    }
}
impl From<ConfigError> for AppError {
    fn from( err: ConfigError ) -> AppError {
        AppError::EnvError( err.to_string() )
    }
}
impl From<IOError> for AppError {
    fn from( err: IOError ) -> AppError {
        AppError::IOError( err.to_string() )
    }
}
impl From<LogError> for AppError {
    fn from( err: LogError ) -> AppError {
        AppError::LogError( err.to_string() )
    }
}

impl Display for AppError {
    fn fmt(&self, f: &mut Formatter<'_>) -> FmtResult {
        let msg = match self {
            Self::IOError( t ) => t.to_string(),
            Self::EnvError( t ) => t.to_string(),
            Self::LogError( t ) => t.to_string(),
            Self::SerializeError( t ) => t.to_string(),
            Self::InternalRequestError( t ) => t.to_string()
        };
        write!(f, "{}", msg)
    }
}

impl ResponseError for AppError {
    fn status_code(&self) -> StatusCode {
        match self {
            Self::IOError( _ ) => StatusCode::INTERNAL_SERVER_ERROR,
            Self::EnvError( _ ) => StatusCode::INTERNAL_SERVER_ERROR,
            _ => StatusCode::INTERNAL_SERVER_ERROR
        }
    }
    fn error_response(&self) -> HttpResponse {
        // error!(target: "errors", "{}", &self.to_string());
        HttpResponse::build( self.status_code() ).json( hashmap! { "error" => self.to_string() } )
    }
}
