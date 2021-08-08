use actix_web::middleware::Logger;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use env_logger::Env;

#[get("/status")]
async fn status() -> impl Responder {
    let version = std::env::var("VERSION").expect("VERSION must be set");

    HttpResponse::Ok()
        .header("content-type", "application/json")
        .body(format!("{{\"version\": \"{}\"}}", version))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    HttpServer::new(|| {
        App::new()
            .wrap(Logger::default())
            .service(status)
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
