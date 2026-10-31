package com.abdownloadmanager.resources.icons

import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.graphics.vector.addPathNodes
import androidx.compose.ui.unit.dp

// AT Download Manager icon: a download arrow inside a "retry" circle
val ABDMIcons.AppIcon: ImageVector
    get() {
        if (_AppIcon != null) {
            return _AppIcon!!
        }
        val brush = Brush.linearGradient(
            colorStops = arrayOf(
                0f to Color(0xFF00C9A7),
                1f to Color(0xFF2F6BFF),
            ),
            start = Offset(0f, 0f),
            end = Offset(512f, 512f),
        )
        _AppIcon = ImageVector.Builder(
            name = "AppIcon",
            defaultWidth = 48.dp,
            defaultHeight = 48.dp,
            viewportWidth = 512f,
            viewportHeight = 512f,
        ).apply {
            // retry circle
            addPath(
                pathData = addPathNodes("M331.0,126.1 A150,150 0 1,1 181.0,126.1"),
                stroke = brush,
                strokeLineWidth = 40f,
                strokeLineCap = StrokeCap.Butt,
            )
            // retry arrow head
            addPath(
                pathData = addPathNodes("M231.2,97.1 L152.8,89.3 L198.8,168.9 Z"),
                fill = brush,
                stroke = brush,
                strokeLineWidth = 8f,
                strokeLineJoin = StrokeJoin.Round,
            )
            // download arrow
            addPath(
                pathData = addPathNodes("M256,178 L256,316"),
                stroke = brush,
                strokeLineWidth = 40f,
                strokeLineCap = StrokeCap.Round,
            )
            addPath(
                pathData = addPathNodes("M198,262 L256,320 L314,262"),
                stroke = brush,
                strokeLineWidth = 40f,
                strokeLineCap = StrokeCap.Round,
                strokeLineJoin = StrokeJoin.Round,
            )
        }.build()

        return _AppIcon!!
    }

@Suppress("ObjectPropertyName")
private var _AppIcon: ImageVector? = null
