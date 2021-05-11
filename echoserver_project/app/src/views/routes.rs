use actix_web::client::Client;
use actix_web::web::{ Data, Query, Path, Json };
use quoted_string::strip_dquotes;

use crate::settings::AppConfig;
use crate::core::errors::AppError;
use crate::core::requests::GetFromUrl;
use crate::core::responses::ResponseHealth;




/** Get response from HTTP resource */
pub async fn get_resource(app_config: Data<AppConfig>, query: Query<GetFromUrl>) -> Result<Json<ResponseHealth>, AppError> {
    let query_url = strip_dquotes( &query.url ).unwrap_or( &query.url );

    let mut client = Client::default();
    let response_code = client.get( query_url )
        .send()
        .await ?
        .status().to_string();

    let resp = ResponseHealth {
        status: response_code,
        version: app_config.version.clone()
    };

    Ok( Json( resp ) )
}
