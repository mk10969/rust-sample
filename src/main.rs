extern crate chrono;
extern crate chrono_tz;

use chrono::Utc;
use chrono_tz::Asia::Tokyo;
use cron::Schedule;
use dotenv::dotenv;
use std::{env, str::FromStr};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    dotenv().ok();
    env::set_var("RUST_LOG", "info");
    env_logger::init();

    log::info!("=> collector job start");
    cron_loop().await?;
    Ok(())
}

async fn cron_loop() -> anyhow::Result<()> {
    let join_handle = tokio::spawn(async move {
        //                    sec   min    hour  day of month  month  day of week  year
        let expression = "0   20,50   10-23      *          *        *         *";
        let schedule = Schedule::from_str(expression).unwrap();

        loop {
            let datetime = schedule.upcoming(Tokyo).take(1).collect::<Vec<_>>()[0];
            let tokyo_now = Utc::now().with_timezone(&Tokyo);

            log::info!(
                "-> datetime: {} now: {} diff: {}",
                datetime,
                tokyo_now,
                datetime - tokyo_now
            );
            tokio::time::sleep(core::time::Duration::from_secs(1)).await;
        }
    });

    join_handle.await?;
    Ok(())
}
