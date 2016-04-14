module.exports = {
    entry: './src/index.js',
    output: {
        path: './dist',
        filename: 'index.js'
    },
    resolve: {
        moduleDirectories: ['node_modules'],
        extensions: ['', '.js', '.elm']
    },
    module: {
        loaders: [
            {
                test: /\.html$/,
                exclude: /node_modules/,
                loader: 'file?name=[name].[ext]'
            },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-webpack'
            }
        ],
        noParse: [/.elm$/]
    },
    devServer: {
        stats: 'errors-only'
    }
};
