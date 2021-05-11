use serde::Deserialize;




#[derive(Debug, Deserialize)]
pub struct GetFromUrl {
    pub url: String
}
