import 'dotenv/config'
import { webkit } from 'playwright'
;(async function main() {
	const start = performance.now()
	const browser = await webkit.launch()
	const page = await browser.newPage()
	await page.goto('https://nicolastoulemont.dev')
	await page.screenshot({ path: `screenshots/blog.png`, fullPage: true })
	await browser.close()
	const end = performance.now()
	console.log(`Execution time: ${(end - start) / 1000} seconds.`)
})()
