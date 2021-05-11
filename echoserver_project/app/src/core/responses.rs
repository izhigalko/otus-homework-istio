use serde::{ Serialize, Deserialize };




#[derive(Serialize, Deserialize)]
pub struct ResponseHealth {
    pub status: String,
    pub version: String
}
