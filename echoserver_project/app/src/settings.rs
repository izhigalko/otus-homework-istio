use serde::Deserialize;

use config::{ ConfigError, Config, Environment };




#[derive(Debug, Clone, Deserialize)]
pub struct AppConfig {
    pub version: String
}
impl AppConfig {
    pub fn new() -> Result<Self, ConfigError> {
        let mut conf = Config::new();
        conf.merge( Environment::with_prefix( "APP" ) ) ?;
        conf.try_into::<Self>()
    }
}
