// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math' show Rectangle, pi;
import 'package:charts_common/common.dart';
import 'package:charts_common/src/data/series.dart' show AccessorFn;
import 'package:meta/meta.dart' show required;


class CustomBarLabelDecorator<D> extends BarRendererDecorator<D> {
  // Default configuration
  static const _defaultLabelPosition = CustomBarLabelPosition.auto;
  static const _defaultLabelPadding = 5;
  static const _defaultLabelAnchor = CustomBarLabelAnchor.start;
  static final _defaultInsideLabelStyle =
  new TextStyleSpec(fontSize: 12, color: Color.white);
  static final _defaultOutsideLabelStyle =
  new TextStyleSpec(fontSize: 12, color: Color.black);

  /// Configures [TextStyleSpec] for labels placed inside the bars.
  final TextStyleSpec insideLabelStyleSpec;

  /// Configures [TextStyleSpec] for labels placed outside the bars.
  final TextStyleSpec outsideLabelStyleSpec;

  /// Configures where to place the label relative to the bars.
  final CustomBarLabelPosition labelPosition;

  /// For labels drawn inside the bar, configures label anchor position.
  final CustomBarLabelAnchor labelAnchor;

  /// Space before and after the label text.
  final int labelPadding;

  CustomBarLabelDecorator(
      {TextStyleSpec insideLabelStyleSpec,
        TextStyleSpec outsideLabelStyleSpec,
        this.labelPosition: _defaultLabelPosition,
        this.labelPadding: _defaultLabelPadding,
        this.labelAnchor: _defaultLabelAnchor})
      : insideLabelStyleSpec = insideLabelStyleSpec ?? _defaultInsideLabelStyle,
        outsideLabelStyleSpec =
            outsideLabelStyleSpec ?? _defaultOutsideLabelStyle;

  @override
  void decorate(Iterable<ImmutableBarRendererElement<D>> barElements,
      ChartCanvas canvas, GraphicsFactory graphicsFactory,
      {@required Rectangle drawBounds,
        @required double animationPercent,
        @required bool renderingVertically,
        bool rtl: false}) {
    // Only decorate the bars when animation is at 100%.
    if (animationPercent != 1.0) {
      return;
    }
    // Create [TextStyle] from [TextStyleSpec] to be used by all the elements.
    // The [GraphicsFactory] is needed so it can't be created earlier.
    final insideLabelStyle =
    _getTextStyle(graphicsFactory, insideLabelStyleSpec);
    final outsideLabelStyle =
    _getTextStyle(graphicsFactory, outsideLabelStyleSpec);

    for (var element in barElements) {
      final labelFn = element.series.labelAccessorFn;
      final datumIndex = element.index;
      final label = (labelFn != null) ? labelFn(datumIndex) : null;

      // If there are custom styles, use that instead of the default or the
      // style defined for the entire decorator.
      final datumInsideLabelStyle = _getDatumStyle(
          element.series.insideLabelStyleAccessorFn,
          datumIndex,
          graphicsFactory,
          defaultStyle: insideLabelStyle);
      final datumOutsideLabelStyle = _getDatumStyle(
          element.series.outsideLabelStyleAccessorFn,
          datumIndex,
          graphicsFactory,
          defaultStyle: outsideLabelStyle);

      // Skip calculation and drawing for this element if no label.
      if (label == null || label.isEmpty) {
        continue;
      }

      final bounds = element.bounds;

      // Get space available inside and outside the bar.
      final totalPadding = labelPadding * 2;
      final insideBarWidth = bounds.width - totalPadding;
      final outsideBarWidth = drawBounds.width - bounds.width - totalPadding;
      final insideBarHeight = bounds.height - totalPadding;
      final outsideBarHeight = drawBounds.height - bounds.height - totalPadding;

      final labelElement = graphicsFactory.createTextElement(label);
      var calculatedLabelPosition = labelPosition;
      if (calculatedLabelPosition == CustomBarLabelPosition.auto) {
        // For auto, first try to fit the text inside the bar.
        labelElement.textStyle = datumInsideLabelStyle;

        // A label fits if the space inside the bar is >= outside bar or if the
        // length of the text fits and the space. This is because if the bar has
        // more space than the outside, it makes more sense to place the label
        // inside the bar, even if the entire label does not fit.
        if (renderingVertically) {
          calculatedLabelPosition = (insideBarHeight >= outsideBarHeight ||
              labelElement.measurement.verticalSliceWidth < insideBarHeight)
              ? CustomBarLabelPosition.inside
              : CustomBarLabelPosition.outside;
        } else {
          calculatedLabelPosition = (insideBarWidth >= outsideBarWidth ||
              labelElement.measurement.horizontalSliceWidth <
                  insideBarWidth)
              ? CustomBarLabelPosition.inside
              : CustomBarLabelPosition.outside;
        }
      }
      // Set the max width and text style.
      if (calculatedLabelPosition == CustomBarLabelPosition.inside) {
        labelElement.textStyle = datumInsideLabelStyle;
        labelElement.maxWidth = renderingVertically ? insideBarHeight : insideBarWidth;
      } else {
        labelElement.textStyle = datumOutsideLabelStyle;
        labelElement.maxWidth = renderingVertically ? outsideBarHeight : outsideBarWidth;
      }

      // Only calculate and draw label if there's actually space for the label.
      if (labelElement.maxWidth > 0) {
        // Calculate the start position of label based on [labelAnchor].

        final int labelX = renderingVertically
            ? _calculateOffsetXVertical(calculatedLabelPosition,bounds, labelElement)
            : _calculateOffsetX(
            bounds, labelElement, calculatedLabelPosition, rtl);
        final int labelY = renderingVertically
            ? _calculateOffsetYVertical(
            bounds, labelElement, calculatedLabelPosition, rtl)
            : _calculateOffsetY(bounds, labelElement);
        canvas.drawText(labelElement, labelX, labelY, rotation: 0); // KK
        /*canvas.drawText(labelElement, labelX, labelY,
            rotation: renderingVertically ? 3 * pi / 2 : 0);*/
      }
    }
  }

  /*int _calculateOffsetXVertical(
      Rectangle<int> bounds, TextElement labelElement) {
    return (bounds.left +
        (bounds.width) / 2 -
        labelElement.measurement.verticalSliceWidth / 2)
        .round();
  }*/

  int _calculateOffsetXVertical(CustomBarLabelPosition position, Rectangle<int> bounds, TextElement labelElement) {
    if(position == CustomBarLabelPosition.outside)
      return (bounds.left + (bounds.width) / 2 - labelElement.measurement.verticalSliceWidth / 2).round();
    else
      return (bounds.left + (bounds.width) / 2 + labelElement.measurement.horizontalSliceWidth / 2).round();

  }

  int _calculateOffsetX(Rectangle<int> bounds, TextElement labelElement,
      CustomBarLabelPosition calculatedLabelPosition, bool rtl) {
    int result = 0;
    if (calculatedLabelPosition == CustomBarLabelPosition.inside) {
      switch (labelAnchor) {
        case CustomBarLabelAnchor.middle:
          result = (bounds.left +
              bounds.width / 2 -
              labelElement.measurement.horizontalSliceWidth / 2)
              .round();
          labelElement.textDirection =
          rtl ? TextDirection.rtl : TextDirection.ltr;
          break;

        case CustomBarLabelAnchor.end:
        case CustomBarLabelAnchor.start:
          final alignLeft = rtl
              ? (labelAnchor == CustomBarLabelAnchor.end)
              : (labelAnchor == CustomBarLabelAnchor.start);

          if (alignLeft) {
            result = bounds.left + labelPadding;
            labelElement.textDirection = TextDirection.ltr;
          } else {
            result = bounds.right - labelPadding;
            labelElement.textDirection = TextDirection.rtl;
          }
          break;
      }
    } else {
      // calculatedLabelPosition == LabelPosition.outside
      result = bounds.right + labelPadding;
      labelElement.textDirection = TextDirection.ltr;
    }
    return result;
  }

  int _calculateOffsetY(Rectangle<int> bounds, TextElement labelElement) {
    return (bounds.top +
        (bounds.bottom - bounds.top) / 2 -
        labelElement.measurement.verticalSliceWidth / 2)
        .round();
  }

  int _calculateOffsetYVertical(Rectangle<int> bounds, TextElement labelElement,
      CustomBarLabelPosition calculatedLabelPosition, bool rtl) {
    int result = 0;
    if (calculatedLabelPosition == CustomBarLabelPosition.inside) {
      switch (labelAnchor) {
        case CustomBarLabelAnchor.middle:
          result = (bounds.bottom +
              bounds.height / 2 -
              labelElement.measurement.horizontalSliceWidth / 2)
              .round();
          labelElement.textDirection =
          rtl ? TextDirection.rtl : TextDirection.ltr;
          break;
        case CustomBarLabelAnchor.end:
        case CustomBarLabelAnchor.start:
          final alignLeft = rtl
              ? (labelAnchor == CustomBarLabelAnchor.end)
              : (labelAnchor == CustomBarLabelAnchor.start);

          if (alignLeft) {
            result = bounds.bottom - labelPadding;
            labelElement.textDirection = TextDirection.ltr;
          } else {
            result = bounds.top + labelPadding;
            labelElement.textDirection = TextDirection.rtl;
          }
          break;
      }
    } else {
      // calculatedLabelPosition == LabelPosition.outside
      //result = bounds.top - labelPadding;
      result = bounds.top - labelPadding - 6; // KK
      labelElement.textDirection = TextDirection.ltr;
    }

    return result;
  }

  // Helper function that converts [TextStyleSpec] to [TextStyle].
  TextStyle _getTextStyle(
      GraphicsFactory graphicsFactory, TextStyleSpec labelSpec) {
    return graphicsFactory.createTextPaint()
      ..color = labelSpec?.color ?? Color.black
      ..fontFamily = labelSpec?.fontFamily
      ..fontSize = labelSpec?.fontSize ?? 12;
  }

  /// Helper function to get datum specific style
  TextStyle _getDatumStyle(AccessorFn<TextStyleSpec> labelFn, int datumIndex,
      GraphicsFactory graphicsFactory,
      {TextStyle defaultStyle}) {
    final styleSpec = (labelFn != null) ? labelFn(datumIndex) : null;
    return (styleSpec != null)
        ? _getTextStyle(graphicsFactory, styleSpec)
        : defaultStyle;
  }
}

/// Configures where to place the label relative to the bars.
enum CustomBarLabelPosition {
  /// Automatically try to place the label inside the bar first and place it on
  /// the outside of the space available outside the bar is greater than space
  /// available inside the bar.
  auto,

  /// Always place label on the outside.
  outside,

  /// Always place label on the inside.
  inside,
}

/// Configures where to anchor the label for labels drawn inside the bars.
enum CustomBarLabelAnchor {
  /// Anchor to the measure start.
  start,

  /// Anchor to the middle of the measure range.
  middle,

  /// Anchor to the measure end.
  end,
}