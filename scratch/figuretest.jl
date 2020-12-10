using CairoMakie
CairoMakie.activate!(type = "png")

##

fig, ax, bars = errorbars(1:10, 1:10, 1:10, color = 1:10, colormap = :viridis,
    figure = (resolution = (800, 600), font = "Helvetica Light"))

ax.backgroundcolor = :gray95

ax, scat = scatter(fig[1, 2], 1:10, 1:10, axis = (title = "hello", xlabel = "green"))

lines(fig[2, :], cumsum(randn(1000000)))
lines!(fig[2, :], cumsum(randn(1000000)), color = "green")
lines!(fig[2, :], cumsum(randn(1000000)), color = "red")

heatmap(fig[:, 3], randn(10, 20), axis = (;title = "heatmap"))

fig

##

fig, _ = scatter(randn(100))

lines(fig[1, 2], randn(100))
lines!(fig[1, 2], randn(100) .+ 1, color = :red)
lines(fig[2, :], randn(100))

fig

##

fig = Figure()


##
fig = Figure(resolution = (900, 900))
scatter(fig[1, 1], randn(100, 2), axis = (;title = "Random Dots", xlabel = "Time"))
lines(fig[1, 2], 0..3, sin ∘ exp, axis = (;title = "Exponential Sine"))
heatmap(fig[2, 1:2][1, 1], randn(30, 30))
heatmap(fig[2, 1:2][1, 2], randn(30, 30), colormap = :grays)
lines!(fig[2, 1:2][1, 2], cumsum(rand(30)), color = :red, linewidth = 10)
fig[2, 1:2][1, 3][1, 1] = LAxis(fig.scene)
fig[2, 1:2][1, 3][2, 1] = LColorbar(fig.scene, vertical = false, height = 20, ticklabelalign = (:center, :bottom))
fig[0, :] = LText(fig.scene, "Figure Demo")
fig