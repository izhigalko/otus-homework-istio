use actix_web::web::{ Json, Data };

use crate::settings::AppConfig;
use crate::core::errors::AppError;
use crate::core::responses::ResponseHealth;




/** Service health check */
pub async fn service_status(app_config: Data<AppConfig>) -> Result<Json<ResponseHealth>, AppError> {
    let resp = ResponseHealth {
        status: "OK".to_string(),
        version: app_config.version.clone()
    };
    Ok( Json( resp ) )
}
