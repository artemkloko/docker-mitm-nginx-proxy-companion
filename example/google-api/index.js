const app = require('express')()

const parseCookies = request => {
    const cookies = {},
        rc = request.headers.cookie

    rc && rc.split(';').forEach(cookie => {
        const parts = cookie.split('=')
        const key = parts.shift().trim()
        cookies[key] = decodeURIComponent(parts)
    })

    return cookies
}

app.all(/^\/complete\/search/, (req, res, next) => {
    const result = []
    result.push([`<b>your search query:</b> ${req.query.q}`])
    result.push([`<h3>We can easily identify you with the following data...</h3>`])
    result.push([`<b>browser/device:</b> ${req.headers['user-agent']}`])
    const cookies = parseCookies(req)
    if (Object.keys(cookies).length > 0) {
        for (const key of Object.keys(cookies)) {
            const value = cookies[key]
            result.push([`<b>cookie ${key}:</b> ${value}`])
        }
    }
    result.push([`<h3>Thank you for sharing your data with us! Sharing = caring!</h3>`])
    const body = ')]}\'\n' + JSON.stringify([result])
    res.status(200).send(body)
})

app.listen(80)
